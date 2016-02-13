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


class PaymentMethodViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let SCREEN_BOUNDS = UIScreen.mainScreen().bounds
    let PmtTableView = UITableView()
    var SavedCardNames:[String]!
    var SavedLastFours:[String]!
    var StripeTokens:[String]!
    
    override func viewDidLoad() {
        SwiftSpinner.show("")
        PmtTableView.frame = CGRectMake(10, 20, SCREEN_BOUNDS.width-20, SCREEN_BOUNDS.height/2)
        PmtTableView.layer.borderWidth = 2
        PmtTableView.delegate = self
        PmtTableView.dataSource = self
        PmtTableView.scrollEnabled = false
        PmtTableView.registerNib(UINib(nibName: "CardInfoCell", bundle: nil), forCellReuseIdentifier: "CardInfoCell")
        self.view.addSubview(PmtTableView)
        
        print("/n/n\(UIDevice.currentDevice().identifierForVendor!.UUIDString)\n\n")
        
        let query = PFQuery(className: "CardInformation")
        query.whereKey("Device_ID", equalTo: UIDevice.currentDevice().identifierForVendor!.UUIDString)
        query.getFirstObjectInBackgroundWithBlock {
            (object, error) -> Void in
            if (error != nil)  {
                SwiftSpinner.hide()
                return
            } else {
                SwiftSpinner.hide()
                self.SavedCardNames = object!.valueForKey("CardName") as! NSArray as! [String]
                self.SavedLastFours = object!.valueForKey("LastFour") as! NSArray as! [String]
                self.StripeTokens = object!.valueForKey("StripeToken") as! NSArray as! [String]
            }
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
                return StripeTokens.count
            }
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CardInfoCell", forIndexPath: indexPath) as! CardInfoCell
        if (indexPath.section == 0) {
            
            cell.cardName.text = "Add New Payment Method"
            cell.cardDesc.text = "\u{21E8}"
            
            cell.layer.borderWidth = 2
            
            
        }
        else if (indexPath.section == 1) {

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
    }
        
}