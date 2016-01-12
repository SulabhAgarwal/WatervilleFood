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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Auto-set the UITableViewCells height (requires iOS8+)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        tableView.delegate = self
        tableView.dataSource = self
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