//
//  CartCheckoutViewController.swift
//  WatervilleFood
//
//  Created by Daniel Vogel on 1/14/16.
//  Copyright © 2016 Daniel Vogel. All rights reserved.
//

import Foundation
import UIKit

class OrderSummaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let SCREEN_BOUNDS = UIScreen.mainScreen().bounds
    let CheckoutButton : UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Order"
        let titleButton: UIButton = UIButton(frame: CGRectMake(0,0,100,32))
        titleButton.setTitle("Order Summary", forState: UIControlState.Normal)
        titleButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 25.0)
        titleButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        self.navigationItem.titleView = titleButton

        let tableView:UITableView = UITableView(frame: CGRectMake(10,10,SCREEN_BOUNDS.width-20,SCREEN_BOUNDS.height-60))
        tableView.delegate      =   self
        tableView.dataSource    =   self
        tableView.scrollEnabled = false
        tableView.registerNib(UINib(nibName: "CustomCartCell", bundle: nil), forCellReuseIdentifier: "CartCell")
        tableView.tableFooterView = UIView(frame: CGRectZero)
        self.view.addSubview(tableView)
        
        CheckoutButton.frame = CGRectMake(20,SCREEN_BOUNDS.height-50,SCREEN_BOUNDS.width-40,40)
        CheckoutButton.setTitle("Checkout", forState: UIControlState.Normal)
        CheckoutButton.layer.backgroundColor = UIColor.blackColor().CGColor
        CheckoutButton.addTarget(self, action: "checkoutPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        if (Order.items.count == 0) {
            CheckoutButton.alpha = 0.5
            CheckoutButton.enabled = false
        }
        self.view.addSubview(CheckoutButton)
        
    }
    
    func checkoutPressed(sender: UIButton) {
        let mapViewControllerObejct = self.storyboard?.instantiateViewControllerWithIdentifier("CheckoutVC") as? CheckoutViewController
        self.navigationController?.pushViewController(mapViewControllerObejct!, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return Order.items.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Order Summary (swipe to delete)"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CartCell", forIndexPath: indexPath) as! CustomCartCell
        
        cell.itemName.text = Order.items[indexPath.row][0] as? String
        cell.itemPrice.text = "$\(String.localizedStringWithFormat("%.2f %@", (Order.items[indexPath.row][2] as? Double)!,""))"
        print(Order.items)
        for section in Order.items[indexPath.row][1] as! [[AnyObject]] {
            for option in section[1] as! [AnyObject]{
                cell.itemOptions.text = cell.itemOptions.text! + " " + (option as! String) as String
                
            }
            
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .Normal, title: "Delete") { action, index in
            Order.items.removeAtIndex(indexPath.row)
            if (Order.items.count == 0) {
                self.CheckoutButton.alpha = 0.5
                self.CheckoutButton.enabled = false
            }
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            JSSAlertView().danger(self, title: "Item deleted from order", text: "")
        }
        delete.backgroundColor = UIColor.redColor()
        
        return [delete]
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // the cells you would like the actions to appear needs to be editable
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // you need to implement this method too or you can't swipe to display the actions
    }
        
}