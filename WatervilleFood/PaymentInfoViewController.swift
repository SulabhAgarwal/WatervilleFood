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

class PaymentInfoViewController : UIViewController , STPPaymentCardTextFieldDelegate {
    let paymentTextField = STPPaymentCardTextField()
    let flatSwitch = AIFlatSwitch()
    var isValid:Bool = false
    let SCREEN_BOUNDS = UIScreen.mainScreen().bounds
    
    override func viewDidLoad() {
        super.viewDidLoad();
        paymentTextField.frame = CGRectMake(10, 100, SCREEN_BOUNDS.width-20, 44)
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
    }
    
    func paymentCardTextFieldDidChange(textField: STPPaymentCardTextField) {
        // Toggle navigation, for example
        if (textField.valid == true) {
            flatSwitch.strokeColor = UIColor.greenColor()
            flatSwitch.trailStrokeColor = UIColor.greenColor()
            flatSwitch.setSelected(true, animated: true)
            isValid = true
        }
        else {
            if (isValid) {
                flatSwitch.strokeColor = UIColor.redColor()
                flatSwitch.trailStrokeColor = UIColor.redColor()
                flatSwitch.setSelected(false, animated: true)
                isValid = false
            }
        }
    }
    
    
}