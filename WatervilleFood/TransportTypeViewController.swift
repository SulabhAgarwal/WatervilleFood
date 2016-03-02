//
//  TransportTypeViewController.swift
//  WatervilleFood
//
//  Created by Daniel Vogel on 2/28/16.
//  Copyright © 2016 Daniel Vogel. All rights reserved.
//

import Foundation
import UIKit

class TransportTypeViewController:UIViewController {
    
    let SCREEN_BOUNDS = UIScreen.mainScreen().bounds
    
    override func viewWillAppear(animated:Bool) {
        
        self.title = "Delivery Method"
        
        if (Order.Restaurant.valueForKey("Delivers") as! Bool! == false) {
            let CarryoutOnly:UIButton = UIButton(frame: CGRectMake(SCREEN_BOUNDS.width/2 - 100, SCREEN_BOUNDS.height/2 - 100, 200, 200))
            CarryoutOnly.setTitle("Carryout Only", forState: .Normal)
            CarryoutOnly.setTitleColor(UIColor.blackColor(), forState: .Normal)
            CarryoutOnly.titleEdgeInsets = UIEdgeInsetsMake(-100, 0, 0, 0)
            CarryoutOnly.layer.borderWidth = 5
            CarryoutOnly.layer.cornerRadius = 5
            CarryoutOnly.addTarget(self, action: "carryoutPressed:", forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(CarryoutOnly)
            
            let bagImage:UIImageView = UIImageView(frame:CGRectMake(CarryoutOnly.bounds.width/2-50, CarryoutOnly.bounds.height/2-20, 100, 100))
            bagImage.image = UIImage(named: "silhouette")
            CarryoutOnly.addSubview(bagImage)
        }
        else {
            let CarryoutBtn:UIButton = UIButton(frame: CGRectMake(SCREEN_BOUNDS.width/4 - 50, SCREEN_BOUNDS.height/2 - 50, 100, 100))
            CarryoutBtn.setTitle("Carryout", forState: .Normal)
            CarryoutBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
            CarryoutBtn.titleEdgeInsets = UIEdgeInsetsMake(-50, 0, 0, 0)
            CarryoutBtn.layer.borderWidth = 5
            CarryoutBtn.layer.cornerRadius = 5
            CarryoutBtn.addTarget(self, action: "carryoutPressed:", forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(CarryoutBtn)
            
            let bagImage:UIImageView = UIImageView(frame:CGRectMake(CarryoutBtn.bounds.width/2-25, CarryoutBtn.bounds.height/2-10, 50, 50))
            bagImage.image = UIImage(named: "silhouette")
            CarryoutBtn.addSubview(bagImage)
            
            let DeliveryBtn:UIButton = UIButton(frame: CGRectMake(3*SCREEN_BOUNDS.width/4 - 50, SCREEN_BOUNDS.height/2 - 50, 100, 100))
            DeliveryBtn.setTitle("Delivery", forState: .Normal)
            DeliveryBtn.setTitleColor(UIColor.blackColor(), forState: .Normal)
            DeliveryBtn.titleEdgeInsets = UIEdgeInsetsMake(-50, 0, 0, 0)
            DeliveryBtn.layer.borderWidth = 5
            DeliveryBtn.layer.cornerRadius = 5
            DeliveryBtn.addTarget(self, action: "deliveryPressed:", forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(DeliveryBtn)
            
            let carImage:UIImageView = UIImageView(frame:CGRectMake(DeliveryBtn.bounds.width/2-25, DeliveryBtn.bounds.height/2-10, 50, 50))
            carImage.image = UIImage(named: "transport")
            DeliveryBtn.addSubview(carImage)
        }
    }
    
    func carryoutPressed(sender:UIButton) {
        let mapViewControllerObejct = self.storyboard?.instantiateViewControllerWithIdentifier("CheckoutVC") as? CheckoutViewController
        mapViewControllerObejct!.delivery = false
        self.navigationController?.pushViewController(mapViewControllerObejct!, animated: true)
    }
    
    func deliveryPressed(sender:UIButton) {
        let mapViewControllerObejct = self.storyboard?.instantiateViewControllerWithIdentifier("CheckoutVC") as? CheckoutViewController
        
        mapViewControllerObejct!.delivery = true
        self.navigationController?.pushViewController(mapViewControllerObejct!, animated: true)
    }
}
