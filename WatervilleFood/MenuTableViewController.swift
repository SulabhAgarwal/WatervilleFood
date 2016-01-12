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

class MenuTableViewController: UITableViewController {
    
    internal var ItemArray : [PFObject]?
    var options : AnyObject?
    let screenBounds = UIScreen.mainScreen().bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Auto-set the UITableViewCells height (requires iOS8+)
        //tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        tableView.delegate = self
        tableView.dataSource = self
        
        let titleButton: UIButton = UIButton(frame: CGRectMake(0,0,100,32))
        titleButton.setTitle("Test", forState: UIControlState.Normal)
        titleButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 25.0)
        titleButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        titleButton.addTarget(self, action: "titlePressed:", forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.titleView = titleButton
    }
    
    func createNavBar() {
        // Create the navigation bar
        let navigationBar = UINavigationBar(frame: CGRectMake(0, 0, self.view.frame.size.width, 44)) // Offset by 20 pixels vertically to take the status bar into account
        
        navigationBar.backgroundColor = UIColor.whiteColor()
        //navigationBar.delegate =
        
        // Create a navigation item with a title
        let navigationItem = UINavigationItem()
        navigationItem.title = "Waterville Food"
        
        // Create left and right button for navigation item
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "backButton"), forState: .Normal)
        backButton.frame = CGRectMake(0, 0, 30, 30)
        backButton.addTarget(self, action: "back:", forControlEvents: .TouchUpInside)
        let leftButton = UIBarButtonItem()
        leftButton.customView = backButton
        
        let cartButton = UIButton()
        cartButton.setImage(UIImage(named: "shoppingCart"), forState: .Normal)
        cartButton.frame = CGRectMake(0, 0, 30, 30)
        cartButton.addTarget(self, action: "back:", forControlEvents: .TouchUpInside)
        let rightButton = UIBarButtonItem()
        rightButton.customView = cartButton
        
        // Create two buttons for the navigation item
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton
        
        // Assign the navigation item to the navigation bar
        navigationBar.items = [navigationItem]
        
        // Make the navigation bar a subview of the current view controller
        tableView.addSubview(navigationBar)
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
        cell.labTime.text = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .ShortStyle, timeStyle: .ShortStyle)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let optionsArray = ItemArray![indexPath.row].valueForKey("Options")
        self.options = optionsArray
        self.performSegueWithIdentifier("ItemsToOptions", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        let detailVC = segue.destinationViewController as! OptionsTableViewController;
        print(self.options)
        detailVC.optionArray = self.options as! NSArray
    }
    
}