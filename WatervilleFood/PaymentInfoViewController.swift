//
//  PaymentInfoViewController.swift
//  WatervilleFood
//
//  Created by Daniel Vogel on 1/16/16.
//  Copyright © 2016 Daniel Vogel. All rights reserved.
//

import Foundation
import UIKit
import Stripe
import Parse
import TextFieldEffects
import SwiftSpinner



class PaymentInfoViewController : UIViewController , STPPaymentCardTextFieldDelegate {
    
    let paymentTextField = STPPaymentCardTextField()
    var isValid:Bool = false
    var hasName:Bool = false
    let SCREEN_BOUNDS = UIScreen.mainScreen().bounds
    let AddPaymentButton:UIButton = UIButton()
    var nameField:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        nameField = HoshiTextField(frame: CGRectMake(20,80,SCREEN_BOUNDS.width-40,50))
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRectMake(0.0, nameField.frame.height - 1, nameField.frame.width, 1.0)
        bottomLine.backgroundColor = UIColor.blackColor().CGColor
        nameField.borderStyle = UITextBorderStyle.None
        nameField.layer.addSublayer(bottomLine)
        let attributes = [
            NSForegroundColorAttributeName: UIColor.blackColor(),
            NSFontAttributeName : UIFont(name: "Futura", size: 17)!
        ]
        nameField.attributedPlaceholder = NSAttributedString(string: "Card Name", attributes:attributes)
        nameField.addTarget(self, action: "nameDidChange:", forControlEvents: .EditingChanged)
        view.addSubview(nameField)
        
        paymentTextField.frame = CGRectMake(20, 140, SCREEN_BOUNDS.width-40, 45)
        paymentTextField.delegate = self
        view.addSubview(paymentTextField)
        
        
        self.title = "Payment"
        let titleButton: UIButton = UIButton(frame: CGRectMake(0,0,100,32))
        titleButton.setTitle("Payment", forState: UIControlState.Normal)
        titleButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        self.navigationItem.titleView = titleButton
        
        AddPaymentButton.frame = CGRectMake(20,295,SCREEN_BOUNDS.width-40,40)
        AddPaymentButton.setTitle("Add Payment Method", forState: UIControlState.Normal)
        AddPaymentButton.layer.backgroundColor = UIColor.blackColor().CGColor
        AddPaymentButton.addTarget(self, action: "addPaymentPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(AddPaymentButton)
        
        if (!isValid) {
            AddPaymentButton.enabled = false
            AddPaymentButton.alpha = 0.2
        }
        

    }
    
    func nameDidChange(sender: UITextField) {
        if (sender.text == "") {
            hasName = false
            AddPaymentButton.enabled = false
            AddPaymentButton.alpha = 0.2
        }
        else {
            hasName = true
            if (isValid) {
                AddPaymentButton.enabled = true
                AddPaymentButton.alpha = 1
            }
        }
    }
    
    func addPaymentPressed(sender:UIButton) {
        SwiftSpinner.show("Saving Card...")
            if let card = self.paymentTextField.card {
                STPAPIClient.sharedClient().createTokenWithCard(card) { (token, error) -> Void in
                    if let error = error  {
                        dispatch_async(dispatch_get_main_queue(), {
                            SwiftSpinner.hide()
                            let alertview = JSSAlertView().danger(self, title: "Error", text: "\(error.code)")
                            alertview.setTitleFont("Futura")
                            alertview.setTextFont("Futura")
                            alertview.setButtonFont("Futura")
                        })
                    }
                    else if let token = token {
                        if let url = NSURL(string: "http://localhost:4567/cards/create") {
                            
                            let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
                            let request = NSMutableURLRequest(URL: url)
                            request.HTTPMethod = "POST"
                            let postBody = "stripeToken=\(token.tokenId)&name=\(self.nameField.text!)&deviceID=\(UIDevice.currentDevice().identifierForVendor!.UUIDString)"
                            let postData = postBody.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
                            session.uploadTaskWithRequest(request, fromData: postData, completionHandler: { data, response, error in
                                let successfulResponse = (response as? NSHTTPURLResponse)?.statusCode == 200
                                print(successfulResponse)
                                print((response as? NSHTTPURLResponse)?.description)
                                if successfulResponse && error == nil {
                                    dispatch_async(dispatch_get_main_queue(), {
                                        SwiftSpinner.hide()
                                        self.navigationController?.popViewControllerAnimated(true)
                                        let alertview = JSSAlertView().success(self, title: "Great success", text: "Card Saved!")
                                        alertview.setTitleFont("Futura")
                                        alertview.setTextFont("Futura")
                                        alertview.setButtonFont("Futura")
                                    })
                                } else {
                                    if error != nil {
                                        dispatch_async(dispatch_get_main_queue(), {
                                            SwiftSpinner.hide()
                                            let alertview = JSSAlertView().danger(self, title: "Error", text: "\(error?.code)")
                                            alertview.setTitleFont("Futura")
                                            alertview.setTextFont("Futura")
                                            alertview.setButtonFont("Futura")
                                        })
                                    }
                                    else {
                                        dispatch_async(dispatch_get_main_queue(), {
                                            SwiftSpinner.hide()
                                            print("Success?")
                                        })
                                    }
                                }
                            }).resume()
                            
                            return
                        }
                    }
                }
            }
    }
    
    func paymentCardTextFieldDidChange(textField: STPPaymentCardTextField) {
        // Toggle navigation, for example
        if (textField.valid && hasName) {
            isValid = true
            AddPaymentButton.enabled = true
            AddPaymentButton.alpha = 1
            
        }
        else {
            if (isValid) {
                isValid = false
                AddPaymentButton.enabled = false
                AddPaymentButton.alpha = 0.2
            }
        }
    }

    
    

    
    
}