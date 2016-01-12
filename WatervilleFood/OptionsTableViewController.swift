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
    var checkBoxArray:[[Bool]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 44
        tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        tableView.delegate = self
        tableView.dataSource = self
        for i in 0...optionArray.count-1{
            let sectionData = optionArray[i]
            var sectionBoxArray:[Bool] = []
            for _ in 0...sectionData[2].count-1 {
                sectionBoxArray.append(false)
            }
            checkBoxArray.append(sectionBoxArray)
        }
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
        if checkBoxArray[indexPath.section][indexPath.row] == false {
            cell.imgUser.image = UIImage(named: "buttonOff")
        }
        else {
            cell.imgUser.image = UIImage(named: "buttonOn")
        }
        
        cell.labUerName.text = "Test"
        cell.labMessage.text = "Testt"
        cell.labTime.text = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .ShortStyle, timeStyle: .ShortStyle)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if checkBoxArray[indexPath.section][indexPath.row] == true {
            checkBoxArray[indexPath.section][indexPath.row] = false
        }
        else {
           checkBoxArray[indexPath.section][indexPath.row] = true
        }
        self.tableView.reloadData()
    }
    
}