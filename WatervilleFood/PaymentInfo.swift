//
//  PaymentInfo.swift
//  WatervilleFood
//
//  Created by Daniel Vogel on 1/16/16.
//  Copyright © 2016 Daniel Vogel. All rights reserved.
//

import Foundation
import Stripe

class PaymentInfo {
    var name: String!
    var tokenId: String!
    var lastFour: String!
    var customerId: String!
}