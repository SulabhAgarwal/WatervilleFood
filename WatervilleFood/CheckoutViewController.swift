//
//  PaymentViewController.swift
//  WatervilleFood
//
//  Created by Daniel Vogel on 1/15/16.
//  Copyright © 2016 Daniel Vogel. All rights reserved.
//

import Foundation
import UIKit
import Stripe
import Parse

class CheckoutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PaymentInfoDelegate, DeliveryInfoDelegate {

    let SCREEN_BOUNDS = UIScreen.mainScreen().bounds
    var TABLE_NAMES:[String] = []
    let TABLE_ICONS:[UIImage] = [UIImage(named: "Restaurant")!, UIImage(named: "creditCard")!, UIImage(named: "House")!]
    let detailsTableView:UITableView = UITableView()
    let orderTableView:UITableView = UITableView()
    var PmtInfo:PaymentInfo = PaymentInfo()
    var DelInfo:DeliveryInfo = DeliveryInfo()
    let backendChargeURLString = "https://danvtest.herokuapp.com/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.createTableArray()
        
        self.title = "Checkout"
        let titleButton: UIButton = UIButton(frame: CGRectMake(0,0,100,32))
        titleButton.setTitle("Checkout", forState: UIControlState.Normal)
        titleButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 25.0)
        titleButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        self.navigationItem.titleView = titleButton
        
        detailsTableView.frame = CGRectMake(5,5,SCREEN_BOUNDS.width-10,214)
        detailsTableView.layer.borderWidth = 2
        detailsTableView.delegate      =   self
        detailsTableView.dataSource    =   self
        detailsTableView.scrollEnabled = false
        detailsTableView.registerNib(UINib(nibName: "CheckoutCell", bundle: nil), forCellReuseIdentifier: "CheckoutCell")
        self.view.addSubview(detailsTableView)
        
        orderTableView.frame = CGRectMake(5,SCREEN_BOUNDS.height/2,SCREEN_BOUNDS.width-10,SCREEN_BOUNDS.height/2-55)
        orderTableView.delegate      =   self
        orderTableView.dataSource    =   self
        orderTableView.scrollEnabled = true
        orderTableView.registerNib(UINib(nibName: "CustomCartCell", bundle: nil), forCellReuseIdentifier: "CartCell")
        orderTableView.layer.borderWidth = 2
        self.view.addSubview(orderTableView)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        let CheckoutButton : UIButton = UIButton(frame: CGRectMake(20,SCREEN_BOUNDS.height-50,SCREEN_BOUNDS.width-40,40))
        CheckoutButton.setTitle("Tap to pay: $\(String.localizedStringWithFormat("%.2f %@", (self.calculateTotalPrice()),""))", forState: UIControlState.Normal)
        CheckoutButton.layer.backgroundColor = UIColor.blackColor().CGColor
        CheckoutButton.addTarget(self, action: "checkoutPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        if (PmtInfo.lastFour == nil || DelInfo.address == nil) {
            CheckoutButton.alpha = 0.2
            CheckoutButton.enabled = false
        }
        else {
            CheckoutButton.alpha = 1
            CheckoutButton.enabled = true
        }
        print("\n\nTABLE RELOAD")
        self.view.addSubview(CheckoutButton)
    }
    
    func checkoutPressed(sender: UIButton) {
        if let url = NSURL(string: "http://northeatspaymentbackend.herokuapp.com/charge") {
            
            let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            let customerID = self.PmtInfo.customerId
            let amount = calculateTotalPrice()
            let description = "<Description>"
            let token = self.PmtInfo.tokenId
            let accountID = Order.Restaurant.valueForKey("StripeAccountID") as! String!
            let postBody = "stripeToken=\(token)&amount=\(Int(round(amount*100)))&description=\(description)&customerID=\(customerID)&accountID=\(accountID)"
            let postData = postBody.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            session.uploadTaskWithRequest(request, fromData: postData, completionHandler: { data, response, error in
                let successfulResponse = (response as? NSHTTPURLResponse)?.statusCode == 200
                if successfulResponse && error == nil {
                    let order = PFObject(className:"Orders")
                    order["filled"] = false
                    order["address"] = self.DelInfo.address
                    order["town"] = self.DelInfo.town
                    order["zip"] = self.DelInfo.zip
                    order["apt"] = self.DelInfo.apt
                    order["comments"] = self.DelInfo.comments
                    order["order_total"] = self.calculateTotalPrice()
                    order["delivery"] = "delivery"
                    order["phone"] = self.DelInfo.phone
                    order["details"] = Order.items
                    order["restaurant"] = Order.Restaurant.valueForKey("Name") as! String!
                    order.saveInBackgroundWithBlock {
                        (success: Bool, error: NSError?) -> Void in
                        if (success) {
                            Order.items = [[AnyObject]]()
                            Order.Restaurant = nil
                            self.navigationController?.popToRootViewControllerAnimated(true)
                            let alertview = JSSAlertView().success(self, title: "Great success", text: "Order completed. You'll be notified when the restaurant accepts your order!")
                            alertview.setTitleFont("Futura")
                            alertview.setTextFont("Futura")
                            alertview.setButtonFont("Futura")
                        } else {
                            let alertview = JSSAlertView().danger(self, title: "Error", text: "Order could not be submitted. Check your internet connectivity.")
                            alertview.setTitleFont("Futura")
                            alertview.setTextFont("Futura")
                            alertview.setButtonFont("Futura")
                        }
                    }

                } else {
                    if error != nil {
                        print("error \(error?.description)")
                        //completion(.Failure, error)
                    } else {
                        print("error(s)")
                        //completion(.Failure, NSError(domain: StripeDomain, code: 50, userInfo: [NSLocalizedDescriptionKey: "There was an error communicating with your payment backend."]))
                    }
                    
                }
            }).resume()
            
            return
        }
    }

    func didFinishPaymentVC(controller: PaymentMethodViewController, PmtInfo: PaymentInfo) {
        self.PmtInfo = PmtInfo
        self.createTableArray()
        detailsTableView.reloadData()
    }
    
    func didFinishDeliveryVC(controller: DeliveryAddressViewController, DelInfo: DeliveryInfo) {
        self.DelInfo = DelInfo
        self.createTableArray()
        detailsTableView.reloadData()
    }
    
    func createTableArray() {
        TABLE_NAMES = [String]()
        TABLE_NAMES.append(Order.Restaurant.valueForKey("Name") as! String!)
        if (PmtInfo.lastFour == nil) {
            TABLE_NAMES.append("Add Payment Method")
        } else {
            TABLE_NAMES.append("\(PmtInfo.name) ending in \(PmtInfo.lastFour)")
        }
        if (DelInfo.address == nil) {
            TABLE_NAMES.append("Add Delivery Address")
        }
        else {
            TABLE_NAMES.append(DelInfo.address)
        }
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (tableView == detailsTableView) {
            return "Order Details"
        }
        else {
            return "Order Summary"
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if (tableView == detailsTableView) {
            return 3
        }
        else {
            return Order.items.count + 3
        }
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (tableView == detailsTableView) {
            let cell = tableView.dequeueReusableCellWithIdentifier("CheckoutCell", forIndexPath: indexPath) as! CheckoutCell
            
            cell.itemName.text = TABLE_NAMES[indexPath.row]
            cell.itemImage.image = TABLE_ICONS[indexPath.row]
            
            if (TABLE_NAMES[indexPath.row] == "Add Payment Method" || TABLE_NAMES[indexPath.row] == "Add Delivery Address") {
                cell.itemName.textColor = UIColor.redColor()
            }
            else {
                cell.itemName.textColor = UIColor.blackColor()
            }
            

            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("CartCell", forIndexPath: indexPath) as! CustomCartCell
            if (indexPath.row < Order.items.count) {
                
                cell.itemName.text = Order.items[indexPath.row][0] as? String
                cell.itemPrice.text = "$\(String.localizedStringWithFormat("%.2f %@", (Order.items[indexPath.row][2] as? Double)!,""))"
                
                for section in Order.items[indexPath.row][1] as! [[AnyObject]] {
                    for option in section[1] as! [AnyObject]{
                        cell.itemOptions.text = cell.itemOptions.text! + " " + (option as! String) as String
                        
                    }
                    
                }
            }
            else if (indexPath.row == Order.items.count) {
                cell.itemName.text = "Tax"
                cell.itemPrice.text = "$\(String.localizedStringWithFormat("%.2f %@", (Order.tax),""))"
            }
            else if (indexPath.row == Order.items.count + 1) {
                cell.itemName.text = "Tip"
                cell.itemPrice.text = "$\(String.localizedStringWithFormat("%.2f %@", (Order.tip),""))"
            }
            else if (indexPath.row == Order.items.count + 2) {
                cell.itemName.text = "Total"
                cell.itemPrice.text = "$\(String.localizedStringWithFormat("%.2f %@", (self.calculateTotalPrice()),""))"
            }
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (tableView == detailsTableView) {
            if (indexPath.row == 0) {
                if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"comgooglemaps://")!)) {
                    UIApplication.sharedApplication().openURL(NSURL(string:
                        "comgooglemapsurl://\(Order.Restaurant.valueForKey("GoogMapsAddress") as! String!)")!)
                } else {
                    UIApplication.sharedApplication().openURL(NSURL(string:"https://\(Order.Restaurant.valueForKey("GoogMapsAddress") as! String!)")!);
                }
            }
            if (indexPath.row == 1) {
                let mapViewControllerObejct = self.storyboard?.instantiateViewControllerWithIdentifier("PaymentMethodVC") as? PaymentMethodViewController
                mapViewControllerObejct!.delegate = self
                self.navigationController?.pushViewController(mapViewControllerObejct!, animated: true)
            }
            if (indexPath.row == 2) {
                let mapViewControllerObejct = self.storyboard?.instantiateViewControllerWithIdentifier("DeliveryVC") as? DeliveryAddressViewController
                mapViewControllerObejct!.delegate = self
                self.navigationController?.pushViewController(mapViewControllerObejct!, animated: true)
            }
        }
    }
    
    func calculateTotalPrice() -> Double {
        var sum:Double = 0
        for item in Order.items {
            sum += (item[2] as? Double)!
        }
        sum += Order.tax
        sum += Order.tip
        return sum
    }
    
    
    
}