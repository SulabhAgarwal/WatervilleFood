//
//  CustomTableViewCell.swift
//  WatervilleFood
//
//  Created by Daniel Vogel on 1/11/16.
//  Copyright © 2016 Daniel Vogel. All rights reserved.
//

import Foundation

import UIKit

class CustomItemTableViewCell: UITableViewCell {
    
    let labUerName = UILabel()
    let labMessage = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        labUerName.translatesAutoresizingMaskIntoConstraints = false
        labMessage.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(labUerName)
        contentView.addSubview(labMessage)
        
        let viewsDict = [
            "username" : labUerName,
            "message" : labMessage
        ]
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[username]-[message]-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[username]-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[message]-|", options: [], metrics: nil, views: viewsDict))
    }
    
}