//
//  MenuTableViewController.swift
//  WatervilleFood
//
//  Created by Daniel Vogel on 1/11/16.
//  Copyright © 2016 Daniel Vogel. All rights reserved.
//

import Foundation
import Parse
import UIKit



class MenuTableViewController: UITableViewController, OptionsVCDelegate {
    
    internal var ItemArray : [PFObject]?
    var options : AnyObject?
    let screenBounds = UIScreen.mainScreen().bounds
    let cartButton:MIBadgeButton = MIBadgeButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Auto-set the UITableViewCells height (requires iOS8+)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: CGRectZero)
        self.title = "Menu Items"
        let titleButton: UIButton = UIButton(frame: CGRectMake(0,0,100,32))
        titleButton.setTitle("Menu Items", forState: UIControlState.Normal)
        titleButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 25.0)
        titleButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        self.navigationItem.titleView = titleButton

        cartButton.setImage(UIImage(named: "shoppingCart"), forState: .Normal)
        cartButton.frame = CGRectMake(0, 0, 30, 30)
        cartButton.addTarget(self, action: "toCheckout:", forControlEvents: .TouchUpInside)
        let rightButton = UIBarButtonItem()
        rightButton.customView = cartButton
        self.navigationItem.rightBarButtonItem = rightButton
        if (Order.items.count > 0) {
            cartButton.badgeString = String(Order.items.count)
        }
        else {
            cartButton.badgeString = nil
        }
    }
    
    func didFinishOptionsVC(controller: OptionsTableViewController) {
        if (Order.items.count > 0) {
            cartButton.badgeString = String(Order.items.count)
        }
        else {
            cartButton.badgeString = nil
        }
    }
    
    func toCheckout(sender:UIButton) {
        let mapViewControllerObejct = self.storyboard?.instantiateViewControllerWithIdentifier("OrderSummaryVC") as? OrderSummaryViewController
        
        self.navigationController?.pushViewController(mapViewControllerObejct!, animated: true)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (ItemArray?.count)!
    }
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! CustomItemTableViewCell
        
        cell.labUerName.text = ItemArray![indexPath.row].valueForKey("Item") as! String!
        cell.labMessage.text = "$\(String.localizedStringWithFormat("%.2f %@", ItemArray![indexPath.row].valueForKey("Price") as! Double!,""))"
        cell.labTime.text = "Item description"
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let optionsArray = ItemArray![indexPath.row].valueForKey("Options")
        let mapViewControllerObejct = self.storyboard?.instantiateViewControllerWithIdentifier("OptionsTableVC") as? OptionsTableViewController
        mapViewControllerObejct?.optionArray = optionsArray as! NSArray
        mapViewControllerObejct?.item = ItemArray![indexPath.row].valueForKey("Item") as! String!
        mapViewControllerObejct?.price = ItemArray![indexPath.row].valueForKey("Price") as! Double!
        mapViewControllerObejct!.delegate = self
        self.navigationController?.pushViewController(mapViewControllerObejct!, animated: true)
    }
    
    
}