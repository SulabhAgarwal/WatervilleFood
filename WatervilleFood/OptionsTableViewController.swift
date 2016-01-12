//
//  OptionsTableViewController.swift
//  WatervilleFood
//
//  Created by Daniel Vogel on 1/11/16.
//  Copyright © 2016 Daniel Vogel. All rights reserved.
//

import Foundation
import UIKit
import Parse

class OptionsTableViewController : UITableViewController {
    
    internal var optionArray : NSArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(optionArray)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.optionArray.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.optionArray[section][2].count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(self.optionArray[section][1])"
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("optionCell", forIndexPath: indexPath) as! CustomItemTableViewCell
        
        cell.imgUser.image = UIImage(named: "buttonOff")
        
        cell.labUerName.text = "Test"
        cell.labMessage.text = "Testt"
        cell.labTime.text = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .ShortStyle, timeStyle: .ShortStyle)
        
        return cell
    }
    
}