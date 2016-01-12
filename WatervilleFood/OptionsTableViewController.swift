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
        self.createNavBar()
        tableView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0)
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
    }
    
    func createNavBar() {
        // Create the navigation bar
        let navigationBar = UINavigationBar(frame: CGRectMake(0, 20, self.view.frame.size.width, 44)) // Offset by 20 pixels vertically to take the status bar into account
        
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
        self.view.addSubview(navigationBar)
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
        let cell = tableView.dequeueReusableCellWithIdentifier("optionCell", forIndexPath: indexPath) as! CustomOptionTableViewCell
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if checkBoxArray[indexPath.section][indexPath.row] == true {
            checkBoxArray[indexPath.section][indexPath.row] = false
        }
        else {
           checkBoxArray[indexPath.section][indexPath.row] = true
        }
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
}