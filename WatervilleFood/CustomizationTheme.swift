//
//  CustomizationTheme.swift
//  WatervilleFood
//
//  Created by Daniel Vogel on 1/18/16.
//  Copyright © 2016 Daniel Vogel. All rights reserved.
//

import Foundation
import UIKit

class Theme {
    static func applyButton() {
        applyToUIButton()
        // ...
    }
    static func applyLabel() {
        applyToUILabel()
    }
    static func applyBarButton() {
        applyToUIBarButton()
    }
    
    // It can either theme a specific UIButton instance, or defaults to the appearance proxy (prototype object) by default
    static func applyToUIButton(button: UIButton = UIButton.appearance()) {
        button.titleLabelFont = UIFont(name: "Futura", size:20.0)
        // other UIButton customizations
    }
    
    static func applyToUILabel(label: UILabel = UILabel.appearance()) {
        label.font = UIFont(name:"Futura", size: 14.0)
    }
    
    static func applyToUIBarButton(barbutton: UIBarButtonItem=UIBarButtonItem.appearance()) {
        let font = UIFont(name:"Futura", size: 13)
        barbutton.setTitleTextAttributes([NSFontAttributeName: font!], forState: UIControlState.Normal)
    }
}
