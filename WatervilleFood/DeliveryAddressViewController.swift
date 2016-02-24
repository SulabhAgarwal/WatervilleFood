//
//  DeliveryAddressViewController.swift
//  WatervilleFood
//
//  Created by Daniel Vogel on 1/17/16.
//  Copyright © 2016 Daniel Vogel. All rights reserved.
//

import Foundation
import UIKit
import TextFieldEffects
import UIColor_Hex_Swift

protocol DeliveryInfoDelegate {
    func didFinishDeliveryVC(controller: DeliveryAddressViewController, DelInfo: DeliveryInfo)
}

class DeliveryAddressViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    let tableView:UITableView = UITableView()
    let SCREEN_BOUNDS = UIScreen.mainScreen().bounds
    let PLACEHOLDERS:[String] = ["Address*", "Town*", "Apt/Suite","Zip*", "Phone*", "Comments"]
    var AddressDict:[String:String] = ["Address*":"", "Town*":"", "Apt/Suite":"","Zip*":"", "Phone*":"", "Comments":""]
    let addAddressButton : UIButton = UIButton()
    var DelInfo = DeliveryInfo()
    var delegate:DeliveryInfoDelegate! = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        self.title = "Address Entry"
        let titleButton: UIButton = UIButton(frame: CGRectMake(0,0,100,32))
        titleButton.setTitle("Address", forState: UIControlState.Normal)
        titleButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 25.0)
        titleButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        self.navigationItem.titleView = titleButton
        
        tableView.frame = CGRectMake(5, 5, SCREEN_BOUNDS.width-10, SCREEN_BOUNDS.height-60)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.scrollEnabled = false
        self.view.addSubview(tableView)
        
        tableView.registerNib(UINib(nibName: "DeliveryTableCell", bundle: nil), forCellReuseIdentifier: "DeliveryCell")
        tableView.separatorColor = UIColor.blackColor()
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
         addAddressButton.frame = CGRectMake(20,SCREEN_BOUNDS.height-50,SCREEN_BOUNDS.width-40,40)
        addAddressButton.setTitle("Use this address", forState: UIControlState.Normal)
        addAddressButton.layer.backgroundColor = UIColor.blackColor().CGColor
        addAddressButton.addTarget(self, action: "saveAddressPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        addAddressButton.alpha = 0.2
        addAddressButton.enabled = false
        self.view.addSubview(addAddressButton)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if (textField.tag == 5) {
            return false
        }
        self.view.viewWithTag(textField.tag + 1)?.becomeFirstResponder()
        return true
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("DeliveryCell", forIndexPath: indexPath) as! DeliveryTableCell
        let textField:HoshiTextField = HoshiTextField(frame: CGRectMake(0,0,cell.bounds.width,cell.bounds.height))
        let attributes = [
            NSForegroundColorAttributeName: UIColor.blackColor(),
            NSFontAttributeName : UIFont(name: "Futura", size: 16)!
        ]
        textField.attributedPlaceholder = NSAttributedString(string: Array(AddressDict.keys)[indexPath.row], attributes:attributes)
        textField.font = UIFont(name: "Futura", size: 16)!
        textField.autocorrectionType = .No
        textField.tag = indexPath.row

        
        cell.addSubview(textField)
        
        textField.delegate = self // theField is your IBOutlet UITextfield in your custom cell
        
        textField.placeholder = PLACEHOLDERS[indexPath.row]
        
        return cell
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        AddressDict[textField.placeholder!] = textField.text!
        print(textField.placeholder!)
        if (checkEntries()) {
            addAddressButton.enabled = true
            addAddressButton.alpha = 1
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return 6
    }
    
    func checkEntries() -> Bool {
        for (key, value) in AddressDict {
            if (value == "" && key != "Comments" && key != "Apt/Suite") {
                return false
            }
        }
        return true
    }
    
    func saveAddressPressed(sender:UIButton) {
        self.DelInfo.address = AddressDict["Address*"]
        self.DelInfo.apt = AddressDict["Apt/Suite"]
        self.DelInfo.comments = AddressDict["Comments"]
        print("COMMENTS\(self.DelInfo.comments)")
        self.DelInfo.town = AddressDict["Town*"]
        self.DelInfo.phone = AddressDict["Phone*"]
        self.DelInfo.zip = AddressDict["Zip*"]
        self.navigationController?.popViewControllerAnimated(true)
        self.delegate.didFinishDeliveryVC(self, DelInfo: self.DelInfo)

    }


}
