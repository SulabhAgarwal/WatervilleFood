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


class PaymentMethodViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
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
        SwiftSpinner.hide()
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
                        print(json)
                        let success = json.valueForKey("success")!                                  // Okay, the `json` is here, let's get the value for 'success' out of it
                        print("Success: \(success)")
                    } else {
                        let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)    // No error thrown, but not NSDictionary
                        print("Error could not parse JSON: \(jsonStr)")
                    }
                } catch let parseError {
                    print(parseError)                                                          // Log the error thrown by `JSONObjectWithData`
                    let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                    print("Error could not parse JSON: '\(jsonStr)'")
                }
                
                
//                if successfulResponse && error == nil {
//                    dispatch_async(dispatch_get_main_queue(), {
//                        SwiftSpinner.hide()
//                        self.navigationController?.popViewControllerAnimated(true)
//                        let alertview = JSSAlertView().success(self, title: "Great success", text: "Card Saved!")
//                        alertview.setTitleFont("Futura")
//                        alertview.setTextFont("Futura")
//                        alertview.setButtonFont("Futura")
//                    })
//                } else {
//                    if error != nil {
//                        dispatch_async(dispatch_get_main_queue(), {
//                            SwiftSpinner.hide()
//                            let alertview = JSSAlertView().danger(self, title: "Error", text: "\(error?.code)")
//                            alertview.setTitleFont("Futura")
//                            alertview.setTextFont("Futura")
//                            alertview.setButtonFont("Futura")
//                        })
//                    }
//                }
            }).resume()
            
            return
        }
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
                return StripeTokens.count
            }
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CardInfoCell", forIndexPath: indexPath) as! CardInfoCell
        print(indexPath.section)
        if (indexPath.section == 0) {
            
            cell.cardName.text = "Add New Payment Method"
            cell.cardDesc.text = "\u{21E8}"
            
            cell.layer.borderWidth = 2
            
            
        }
        else {
            print(SavedCardNames[indexPath.row])
            cell.cardName.text = SavedCardNames[indexPath.row]
            cell.cardDesc.text = "****\(SavedLastFours[indexPath.row])"

            
        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.section == 0) {
            let mapViewControllerObejct = self.storyboard?.instantiateViewControllerWithIdentifier("PaymentVC") as? PaymentInfoViewController
            //mapViewControllerObejct!.delegate = self
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