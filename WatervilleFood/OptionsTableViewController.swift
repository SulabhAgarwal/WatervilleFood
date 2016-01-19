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
import Stripe
import ZFRippleButton


class OptionsTableViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    internal var optionArray : NSArray = []
    internal var item : String = String()
    internal var price : Double = Double()
    var checkBoxArray:[[Bool]] = []
    let bounds = UIScreen.mainScreen().bounds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.borderWidth = 2
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
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
        
        let addToOrderButton : ZFRippleButton = ZFRippleButton(frame: CGRectMake(20,bounds.height-50,bounds.width-40,40))
        addToOrderButton.setTitle("Add To Order", forState: UIControlState.Normal)
        addToOrderButton.layer.backgroundColor = UIColor.blackColor().CGColor
        addToOrderButton.addTarget(self, action: "checkoutPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(addToOrderButton)
    }
    
    func checkoutPressed(sender: UIButton) {
        //check number of buttons pressed?
        if (!checkQuantities()) {
            return
        }

        let options = getOptionsForOrder()
        Order.items.append([item,options,price])
        self.navigationController?.popViewControllerAnimated(true)
        JSSAlertView().success(self, title: "Great success", text: "Item added to order!")
        
    }
    
    func checkQuantities() -> Bool{
        for section in 0...self.optionArray.count-1 {
            let specifier = optionArray[section][0] as! [Int]
            let sectionSelected = returnSelectedInSection(section)
            if (specifier[0] == specifier[1]) {
                if (sectionSelected.count != specifier[0]) {
                    JSSAlertView().warning(self, title: "\(optionArray[section][1]) Error", text: "Must pick \(specifier[0])")
                    return false
                }
            }
            else {
                if (sectionSelected.count < specifier[0]) {
                    JSSAlertView().warning(self, title: "\(optionArray[section][1]) Error", text: "Must pick at least \(specifier[0])")
                    return false
                }
                else if (sectionSelected.count > specifier[1]) {
                    JSSAlertView().warning(self, title: "\(optionArray[section][1]) Error", text: "Cannot pick more than \(specifier[1])")
                    return false
                }
            }
        }
        return true
    }
    
    func getOptionsForOrder() -> [[AnyObject]] {
        var orderOptions:[[AnyObject]] = [[AnyObject]]()
        for section in 0...self.optionArray.count-1 {
            let title = self.optionArray[section][1] as! String!
            let optionsSelected = optionArraytoOptionString(section, optionSelected: returnSelectedInSection(section))
            let sectionOptions:[AnyObject] = [title, optionsSelected]
            orderOptions.append(sectionOptions)
        }
        return orderOptions
    }
    
    func optionArraytoOptionString(section: Int, optionSelected:[Int]) -> [String]! {
        var options:[String]! = []
        for option in optionSelected {
            options.append(self.optionArray[section][2][option] as! String!)
        }
        return options
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
            let specifier = optionArray[indexPath.section][0] as! [Int]
            let sectionSelected = returnSelectedInSection(indexPath.section)
            if (specifier[0] == specifier[1] && specifier[1] == 1 && sectionSelected.count == 1) {
                checkBoxArray[indexPath.section][sectionSelected[0]] = false
            }
            checkBoxArray[indexPath.section][indexPath.row] = true
        }
        self.tableView.reloadData()
    }
    
    func returnSelectedInSection(section: Int) -> [Int] {
        var selectedIndexes:[Int] = []
        for cell in 0...checkBoxArray[section].count-1 {
            if checkBoxArray[section][cell] == true {
                selectedIndexes.append(cell)
            }
        }
        return selectedIndexes
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
}