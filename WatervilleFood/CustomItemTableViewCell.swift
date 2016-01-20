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
    
    let imgUser = UIImageView()
    let labUerName = UILabel()
    let labMessage = UILabel()
    let labTime = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgUser.translatesAutoresizingMaskIntoConstraints = false
        labUerName.translatesAutoresizingMaskIntoConstraints = false
        labMessage.translatesAutoresizingMaskIntoConstraints = false
        labTime.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(imgUser)
        contentView.addSubview(labUerName)
        contentView.addSubview(labMessage)
        contentView.addSubview(labTime)
        
        let viewsDict = [
            "image" : imgUser,
            "username" : labUerName,
            "message" : labMessage,
            "labTime" : labTime,
        ]
        
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[message]", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-[username]-[labTime]-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[username]-[message]-|", options: [], metrics: nil, views: viewsDict))
        contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[labTime]-|", options: [], metrics: nil, views: viewsDict))
    }
    
}