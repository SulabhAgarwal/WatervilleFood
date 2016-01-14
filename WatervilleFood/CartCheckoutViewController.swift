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

        let tableView:UITableView = UITableView(frame: CGRectMake(10,10,SCREEN_BOUNDS.width-20,150))
        tableView.delegate      =   self
        tableView.dataSource    =   self
        tableView.registerNib(UINib(nibName: "CustomCartCell", bundle: nil), forCellReuseIdentifier: "CheckoutCell")
        self.view.addSubview(tableView)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CheckoutCell", forIndexPath: indexPath) as! CustomCartCell
        
        cell.itemName.text = "Test"
        
        return cell
    }
        
}