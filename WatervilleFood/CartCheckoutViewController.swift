//
//  CartCheckoutViewController.swift
//  WatervilleFood
//
//  Created by Daniel Vogel on 1/14/16.
//  Copyright © 2016 Daniel Vogel. All rights reserved.
//

import Foundation
import UIKit
import Stripe

class CartCheckoutViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let SCREEN_BOUNDS = UIScreen.mainScreen().bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Checkout"
        let titleButton: UIButton = UIButton(frame: CGRectMake(0,0,100,32))
        titleButton.setTitle("Checkout", forState: UIControlState.Normal)
        titleButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 25.0)
        titleButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        self.navigationItem.titleView = titleButton

        let tableView:UITableView = UITableView(frame: CGRectMake(10,10,SCREEN_BOUNDS.width-20,SCREEN_BOUNDS.height/2))
        tableView.delegate      =   self
        tableView.dataSource    =   self
        tableView.registerNib(UINib(nibName: "CustomCartCell", bundle: nil), forCellReuseIdentifier: "CheckoutCell")
        
        self.view.addSubview(tableView)
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return Order.items.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Order Summary (Swipe Items to Delete)"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CheckoutCell", forIndexPath: indexPath) as! CustomCartCell
        
        cell.itemName.text = Order.items[indexPath.row][0] as? String
        cell.itemPrice.text = "$\(String.localizedStringWithFormat("%.2f %@", (Order.items[indexPath.row][2] as? Double)!,""))"
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
            print(Order.items)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            JSSAlertView().danger(self, title: "Item deleted from order", text: "")
        }
        delete.backgroundColor = UIColor.redColor()

        
        let favorite = UITableViewRowAction(style: .Normal, title: "Info") { action, index in
            print("favorite button tapped")
        }
        favorite.backgroundColor = UIColor.lightGrayColor()
        
        return [delete, favorite]
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // the cells you would like the actions to appear needs to be editable
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        // you need to implement this method too or you can't swipe to display the actions
    }
        
}