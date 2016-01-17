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
import AIFlatSwitch

protocol PaymentInfoDelegate {
    func didFinishPaymentVC(controller: PaymentInfoViewController, PmtInfo: PaymentInfo)
}

class PaymentInfoViewController : UIViewController , STPPaymentCardTextFieldDelegate {
    let paymentTextField = STPPaymentCardTextField()
    let flatSwitch = AIFlatSwitch()
    var isValid:Bool = false
    let SCREEN_BOUNDS = UIScreen.mainScreen().bounds
    let AddPaymentButton:UIButton = UIButton()
    var PmtInfo = PaymentInfo()
    var delegate:PaymentInfoDelegate! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad();
        paymentTextField.frame = CGRectMake(20, 100, SCREEN_BOUNDS.width-40, 45)
        paymentTextField.delegate = self
        view.addSubview(paymentTextField)
        
        
        flatSwitch.frame = CGRectMake(SCREEN_BOUNDS.width/2-25, 170, 50, 50)
        flatSwitch.lineWidth = 2.0
        flatSwitch.strokeColor = UIColor.redColor()
        flatSwitch.trailStrokeColor = UIColor.redColor()
        view.addSubview(flatSwitch)
        
        self.title = "Payment"
        let titleButton: UIButton = UIButton(frame: CGRectMake(0,0,100,32))
        titleButton.setTitle("Payment", forState: UIControlState.Normal)
        titleButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 25.0)
        titleButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        self.navigationItem.titleView = titleButton
        
        AddPaymentButton.frame = CGRectMake(20,245,SCREEN_BOUNDS.width-40,40)
        AddPaymentButton.setTitle("Add Payment Method", forState: UIControlState.Normal)
        AddPaymentButton.layer.backgroundColor = UIColor.blackColor().CGColor
        AddPaymentButton.addTarget(self, action: "addPaymentPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        if (!isValid) {
            AddPaymentButton.enabled = false
            AddPaymentButton.alpha = 0.2
        }
        self.view.addSubview(AddPaymentButton)
    }
    
    func addPaymentPressed(sender:UIButton) {
        if let card = paymentTextField.card {
            STPAPIClient.sharedClient().createTokenWithCard(card) { (token, error) -> Void in
                if let error = error  {
                    print(error.description)
                }
                else if let token = token {
                    self.PmtInfo.token = token
                    self.PmtInfo.lastFour = card.last4()!
                    self.navigationController?.popViewControllerAnimated(true)
                    self.delegate.didFinishPaymentVC(self, PmtInfo: self.PmtInfo)
                    
                }
            }
        }
        
    }
    
    func paymentCardTextFieldDidChange(textField: STPPaymentCardTextField) {
        // Toggle navigation, for example
        if (textField.valid) {
            flatSwitch.strokeColor = UIColor.greenColor()
            flatSwitch.trailStrokeColor = UIColor.greenColor()
            flatSwitch.setSelected(true, animated: true)
            isValid = true
            AddPaymentButton.enabled = true
            AddPaymentButton.alpha = 1
            
        }
        else {
            if (isValid) {
                flatSwitch.strokeColor = UIColor.redColor()
                flatSwitch.trailStrokeColor = UIColor.redColor()
                flatSwitch.setSelected(false, animated: true)
                isValid = false
                AddPaymentButton.enabled = false
                AddPaymentButton.alpha = 0.2
            }
        }
    }
    
    
    func createBackendChargeWithToken(token: STPToken, completion: PKPaymentAuthorizationStatus -> ()) {
        let url = NSURL(string: "https://example.com/token")!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        let body = "stripeToken=(token.tokenId)"
        request.HTTPBody = body.dataUsingEncoding(NSUTF8StringEncoding)
        let configuration = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        let session = NSURLSession(configuration: configuration)
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if error != nil {
                completion(PKPaymentAuthorizationStatus.Failure)
            }
            else {
                completion(PKPaymentAuthorizationStatus.Success)
            }
        }
        task.resume()
    }
    
    
}