//
//  PaymentMethodViewController.swift
//  WatervilleFood
//
//  Created by Daniel Vogel on 2/12/16.
//  Copyright © 2016 Daniel Vogel. All rights reserved.
//

import Foundation
import UIKit
import Stripe
import Parse
import SwiftSpinner

protocol PaymentInfoDelegate {
    func didFinishPaymentVC(controller: PaymentMethodViewController, PmtInfo: PaymentInfo)
}


class PaymentMethodViewController : UIViewController, UITableViewDelegate, UITableViewDataSource, CardInfoDelegate {
    
    let SCREEN_BOUNDS = UIScreen.mainScreen().bounds
    let PmtTableView = UITableView()
    var SavedCardNames:[String]! = []
    var SavedLastFours:[String]! = []
    var StripeTokens:[String]! = []
    let PmtInfo:PaymentInfo = PaymentInfo()
    var delegate:PaymentInfoDelegate! = nil
    
    override func viewDidLoad() {
        SwiftSpinner.show("")
        PmtTableView.frame = CGRectMake(10, 20, SCREEN_BOUNDS.width-20, SCREEN_BOUNDS.height/2)
        PmtTableView.layer.borderWidth = 2
        PmtTableView.delegate = self
        PmtTableView.dataSource = self
        PmtTableView.registerNib(UINib(nibName: "CardInfoCell", bundle: nil), forCellReuseIdentifier: "CardInfoCell")
        self.view.addSubview(PmtTableView)
        
        print("/n/n\(UIDevice.currentDevice().identifierForVendor!.UUIDString)\n\n")
        
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        SwiftSpinner.show("Retrieving Cards...")
        if let url = NSURL(string: "http://localhost:4567/cards/get") {
            
            let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            let postBody = "deviceID=\(UIDevice.currentDevice().identifierForVendor!.UUIDString)"
            let postData = postBody.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            session.uploadTaskWithRequest(request, fromData: postData, completionHandler: { data, response, error in
                let successfulResponse = (response as? NSHTTPURLResponse)?.statusCode == 200
                print(successfulResponse)
                do {
                    if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                        
                        self.SavedCardNames = []
                        self.SavedLastFours = []
                        self.StripeTokens = []
                        
                        let cards = json.valueForKey("cardInfo")!
                        if (cards.count > 0) {
                            for i in 0...(cards.count-1) {
                                self.SavedCardNames.append(cards[i][0]["brand"] as! String!)
                                self.SavedLastFours.append(cards[i][0]["lastFour"] as! String!)
                                self.StripeTokens.append(cards[i][0]["token"] as! String!)
                                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                    self.PmtTableView.reloadSections(NSIndexSet(index: 1), withRowAnimation: .None)
                                    SwiftSpinner.hide()
                                })
                            }
                        }
                        else {
                            SwiftSpinner.hide()
                        }
                    } else {
                        SwiftSpinner.hide()
                        print("Error could not parse JSON:")
                    }
                } catch let parseError {
                    SwiftSpinner.hide()
                    print(parseError)                                                         // Log the error thrown by `JSONObjectWithData`
                }

            }).resume()
            
            return
        }
    }
    
    func didFinishCardInfo(controller: PaymentInfoViewController) {
        print("VIEW WILL APPEAR")
        self.viewWillAppear(true)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            return ""
        }
        else {
            return "Saved Payment Methods"
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if (section == 0) {
            return 1
        }
        else {
            if (StripeTokens == nil) {
                return 0
            }
            else {
                print("count: \(StripeTokens.count)")
                return SavedLastFours.count
            }
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CardInfoCell", forIndexPath: indexPath) as! CardInfoCell
        print("SECTION\(indexPath.section)")
        if (indexPath.section == 0) {
            
            cell.cardName.text = "Add New Payment Method"
            cell.cardDesc.text = "\u{21E8}"
            
            cell.layer.borderWidth = 2
            
            
        }
        else {
            cell.layer.borderWidth = 0
            print("\n\nCARD BRANDS\n\n\(SavedCardNames)")
            cell.cardName.text = SavedCardNames[indexPath.row]
            cell.cardDesc.text = "****\(SavedLastFours[indexPath.row])"

            
        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 0) {
            let mapViewControllerObejct = self.storyboard?.instantiateViewControllerWithIdentifier("PaymentVC") as? PaymentInfoViewController
            mapViewControllerObejct!.delegate = self
            self.navigationController?.pushViewController(mapViewControllerObejct!, animated: true)
            
        }
        else {
            self.PmtInfo.tokenId = StripeTokens[indexPath.row]
            self.PmtInfo.name = SavedCardNames[indexPath.row]
            self.PmtInfo.lastFour = SavedLastFours[indexPath.row]
            self.navigationController?.popViewControllerAnimated(true)
            self.delegate.didFinishPaymentVC(self, PmtInfo: self.PmtInfo)
        }
    }
        
}