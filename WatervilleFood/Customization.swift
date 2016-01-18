//
//  Customization.swift
//  WatervilleFood
//
//  Created by Daniel Vogel on 1/18/16.
//  Copyright © 2016 Daniel Vogel. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    var titleLabelFont: UIFont! {
        get { return self.titleLabel?.font }
        set { self.titleLabel?.font = newValue }
    }
}

extension UILabel {
    var textFont: UIFont! {
        get {return self.font}
        set {self.font = newValue}
    }
}

