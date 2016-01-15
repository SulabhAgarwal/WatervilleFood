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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Checkout"
        let titleButton: UIButton = UIButton(frame: CGRectMake(0,0,100,32))
        titleButton.setTitle("Checkout", forState: UIControlState.Normal)
        titleButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 25.0)
        titleButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        self.navigationItem.titleView = titleButton
        
        let tableView:UITableView = UITableView(frame: CGRectMake(10,10,SCREEN_BOUNDS.width-20,SCREEN_BOUNDS.height-60))
        tableView.delegate      =   self
        tableView.dataSource    =   self
        tableView.scrollEnabled = false
        tableView.registerNib(UINib(nibName: "CheckoutCell", bundle: nil), forCellReuseIdentifier: "CheckoutCell")
        self.view.addSubview(tableView)
        
        
        
        
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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 3
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CheckoutCell", forIndexPath: indexPath) as! CheckoutCell
        
        cell.itemName.text = TABLE_NAMES[indexPath.row]
        cell.itemImage.image = TABLE_ICONS[indexPath.row]

        return cell
    }
    
}