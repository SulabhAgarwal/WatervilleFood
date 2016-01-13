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

class OptionsTableViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    internal var optionArray : NSArray = []
    var checkBoxArray:[[Bool]] = []
    let bounds = UIScreen.mainScreen().bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        optionArray = optionArray as Array
        for i in 0...optionArray.count-1{
            let sectionData = optionArray[i]
            var sectionBoxArray:[Bool] = []
            for _ in 0...sectionData[2].count-1 {
                sectionBoxArray.append(false)
            }
            checkBoxArray.append(sectionBoxArray)
        }
        
        self.title = "Options"
        let titleButton: UIButton = UIButton(frame: CGRectMake(0,0,100,32))
        titleButton.setTitle("Options", forState: UIControlState.Normal)
        titleButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 25.0)
        titleButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        titleButton.addTarget(self, action: "titlePressed:", forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.titleView = titleButton
        
        let checkoutButton : UIButton = UIButton(frame: CGRectMake(20,bounds.height-50,bounds.width-40,40))
        checkoutButton.setTitle("Add To Order", forState: UIControlState.Normal)
        checkoutButton.layer.backgroundColor = UIColor.blackColor().CGColor
        checkoutButton.addTarget(self, action:"addToOrder:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(checkoutButton)
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.optionArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.optionArray[section][2].count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(self.optionArray[section][1])"
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("optionsCell", forIndexPath: indexPath) as! CustomOptionTableViewCell
        if checkBoxArray[indexPath.section][indexPath.row] == false {
            cell.imgUser.image = UIImage(named: "buttonOff")
        }
        else {
            cell.imgUser.image = UIImage(named: "buttonOn")
        }
        
        guard let option = self.optionArray[indexPath.section][2][indexPath.row] else {
            return UITableViewCell()
        }
        cell.labUerName.text = option as? String
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if checkBoxArray[indexPath.section][indexPath.row] == true {
            checkBoxArray[indexPath.section][indexPath.row] = false
        }
        else {
           checkBoxArray[indexPath.section][indexPath.row] = true
        }
        self.tableView.reloadData()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
}