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

class CheckoutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let SCREEN_BOUNDS = UIScreen.mainScreen().bounds
    let TABLE_NAMES:[String] = ["<Restaurant>", "Add Payment Method", "Add Delivery Address"]
    let TABLE_ICONS:[UIImage] = [UIImage(named: "Restaurant")!, UIImage(named: "creditCard")!, UIImage(named: "House")!]
    let detailsTableView:UITableView = UITableView()
    let orderTableView:UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        let CheckoutButton : UIButton = UIButton(frame: CGRectMake(20,SCREEN_BOUNDS.height-50,SCREEN_BOUNDS.width-40,40))
        CheckoutButton.setTitle("Checkout", forState: UIControlState.Normal)
        CheckoutButton.layer.backgroundColor = UIColor.blackColor().CGColor
        CheckoutButton.addTarget(self, action: "checkoutPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        if (Order.items.count == 0) {
            CheckoutButton.alpha = 0.5
            CheckoutButton.enabled = false
        }
        self.view.addSubview(CheckoutButton)
        
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
            return Order.items.count
        }
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (tableView == detailsTableView) {
            let cell = tableView.dequeueReusableCellWithIdentifier("CheckoutCell", forIndexPath: indexPath) as! CheckoutCell
            
            cell.itemName.text = TABLE_NAMES[indexPath.row]
            cell.itemImage.image = TABLE_ICONS[indexPath.row]

            return cell
        }
        else {
            let cell = tableView.dequeueReusableCellWithIdentifier("CartCell", forIndexPath: indexPath) as! CustomCartCell
            cell.itemName.text = Order.items[indexPath.row][0] as? String
            cell.itemPrice.text = "$\(String.localizedStringWithFormat("%.2f %@", (Order.items[indexPath.row][2] as? Double)!,""))"
            
            for section in Order.items[indexPath.row][1] as! [[AnyObject]] {
                for option in section[1] as! [AnyObject]{
                    cell.itemOptions.text = cell.itemOptions.text! + " " + (option as! String) as String
                    
                }
                
            }
            
            return cell

        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (tableView == detailsTableView) {
            if (indexPath.row == 1) {
                let mapViewControllerObejct = self.storyboard?.instantiateViewControllerWithIdentifier("PaymentVC") as? PaymentInfoViewController
                self.navigationController?.pushViewController(mapViewControllerObejct!, animated: true)
            }
        }
    }
    
    
    
}