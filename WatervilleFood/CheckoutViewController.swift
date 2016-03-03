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
import SwiftSpinner
import ActionSheetPicker_3_0

class CheckoutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, PaymentInfoDelegate, DeliveryInfoDelegate {

    let SCREEN_BOUNDS = UIScreen.mainScreen().bounds
    var TABLE_NAMES:[String] = []
    let TABLE_ICONS:[UIImage] = [UIImage(named: "Restaurant")!, UIImage(named: "creditCard")!, UIImage(named: "House")!]
    let detailsTableView:UITableView = UITableView()
    let orderTableView:UITableView = UITableView()
    var PmtInfo:PaymentInfo = PaymentInfo()
    var DelInfo:DeliveryInfo = DeliveryInfo()
    let backendChargeURLString = "https://danvtest.herokuapp.com/"
    var delivery:Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Order.tax = calculateItemsTotal() * 0.08
        Order.tip = calculateItemsTotal() * 0.10
        
        self.createTableArray()
        
        self.title = "Checkout"
        let titleButton: UIButton = UIButton(frame: CGRectMake(0,0,100,32))
        titleButton.setTitle("Checkout", forState: UIControlState.Normal)
        titleButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 25.0)
        titleButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        self.navigationItem.titleView = titleButton
        
        var detailsHeight:CGFloat
        if (delivery == true) {
            detailsHeight = 214
        }
        else {
            detailsHeight = 180
        }
        detailsTableView.frame = CGRectMake(5,5,SCREEN_BOUNDS.width-10,detailsHeight)
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
        if (PmtInfo.lastFour == nil || (DelInfo.address == nil && delivery == true)) {
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
        //must query again in order to double-check that the restaurant is still open. If not, no order
        SwiftSpinner.show("")
        let query = PFQuery(className: "Restaurants")
        query.whereKey("Name", equalTo: Order.Restaurant.valueForKey("Name") as! String!)
        query.getFirstObjectInBackgroundWithBlock {
            (object, error) -> Void in
            if let error = error {
                SwiftSpinner.hide()
                let alertController = UIAlertController(title:"Error", message: "\(error)", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            } else {
                SwiftSpinner.hide()
                let restaurantHours = object!.valueForKey("Hours") as! NSArray as Array
                let hoursForCurrentDay = restaurantHours[self.getCurrentDayOfWeek()-1]
                let currentTime = self.getCurrentTime()
                    
                    
                if (!self.isRestaurantOpen(hoursForCurrentDay as! [[Int]], currentTime: currentTime)) {
                    let alertview = JSSAlertView().danger(self, title: "Error", text: "Restaurant is currently closed. Please order from a restaurant that is open.")
                    alertview.setTitleFont("Futura")
                    alertview.setTextFont("Futura")
                    alertview.setButtonFont("Futura")
                }
                else {
                    print("OPEN!")
                    self.completeOrder()
                }
            }
        }
    }
    
    func completeOrder() {
        
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
                    //need to do the same for DelInfo
                    var delStr="", address="", town="", zip="", apt="", comments=""
                    if (self.delivery == true) {
                        delStr = "delivery"
                        address = self.DelInfo.address
                        town = self.DelInfo.town
                        zip = self.DelInfo.zip
                        apt = self.DelInfo.apt
                        comments = self.DelInfo.comments
                    }
                    else {
                        delStr = "carryout"
                        address = "CARRYOUT"
                    }
                    
                    order["filled"] = false
                    order["address"] = address
                    order["town"] = town
                    order["zip"] = zip
                    order["apt"] = apt
                    order["comments"] = comments
                    order["order_total"] = self.calculateTotalPrice()
                    order["delivery"] = delStr
                    order["phone"] = "Test Phone"
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
            if (delivery == true) {
                return 3
            }
            else {
                return 2
            }
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
                cell.itemName.text = "Tip (tap to change)"
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
        else {
            if (indexPath.row == Order.items.count + 1) {
                self.showTipPickerView(orderTableView.cellForRowAtIndexPath(indexPath)!)
            }
        }
    }
    
    func showTipPickerView(sender: UITableViewCell) {
        let total = calculateItemsTotal()
        ActionSheetStringPicker.showPickerWithTitle("Multiple String Picker", rows:
            ["No Tip - $0.00", "5% - $\(total*0.05)", "10% - $\(total*0.10)", "15% - $\(total*0.15)", "20% - $\(total*0.20)", "25% - $\(total*0.25)"], initialSelection: 1, doneBlock: {
                picker, values, indexes in
                
                print("values = \(values)")
                print("indexes = \(indexes)")
                print("picker = \(picker)")
                return
            }, cancelBlock: { ActionStringCancelBlock in return }, origin: sender)
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
    
    func calculateItemsTotal() -> Double {
        var sum:Double = 0
        for item in Order.items {
            sum += (item[2] as? Double)!
        }
        return sum
    }

    func getCurrentDayOfWeek() -> Int! {
        //Current day of week as int
        let date = NSDate()
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let myComponents = myCalendar.components(.Weekday, fromDate: date)
        let weekDay = myComponents.weekday
        return weekDay
    }

    func getCurrentTime() -> [Int] {
        let date = NSDate()
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([ .Hour, .Minute, .Second], fromDate: date)
        let hour = components.hour
        let minutes = components.minute
        
        return [hour, minutes]
    }
    
    func isRestaurantOpen(hoursForCurrentDay:[[Int]], currentTime:[Int]) -> Bool {
        let openHour = hoursForCurrentDay[0][0]
        let openMinute = hoursForCurrentDay[0][1]
        let closeHour = hoursForCurrentDay[1][0]
        let closeMinute = hoursForCurrentDay[1][1]
        let currentMinute = currentTime[1]
        let currentHour = currentTime[0]
        
        
        
        if (currentHour >= openHour && currentHour <= closeHour) {
            if (currentHour == openHour) {
                if (currentMinute > openMinute) {
                    return true
                } else {
                    return false
                }
            } else if (currentHour == closeHour) {
                if (currentMinute < closeMinute) {
                    return true
                }
                else {
                    return false
                }
            } else {
                return true
            }
        } else {
            return false
        }
    }




}