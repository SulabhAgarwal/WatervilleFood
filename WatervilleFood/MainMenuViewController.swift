//
//  ViewController.swift
//  WatervilleFood
//
//  Created by Daniel Vogel on 1/10/16.
//  Copyright © 2016 Daniel Vogel. All rights reserved.
//

import UIKit
import Parse
import SwiftSpinner
import UIColor_Hex_Swift
import ZFRippleButton

struct Order {
    //[["<order item>","[<options>]","price"], ["<order item>","[<options>]","price"]]
    //[[[0,2],"Topping",["Pepperoni","Sausage","Peppers"]]]
    static var items:[[AnyObject]] = [[AnyObject]]()
    static var tax:Double = 1.00
    static var tip:Double = 1.00
    static var Restaurant:PFObject!
}

class MainMenuViewController: UIViewController {

    let screenBounds = UIScreen.mainScreen().bounds
    var array:[PFObject]?
    var RestaurantArray:[PFObject]! = [PFObject]()
    let cartButton:MIBadgeButton = MIBadgeButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Main"
        
        let titleButton: UIButton = UIButton(frame: CGRectMake(0,0,100,32))
        titleButton.setTitle("Restaurants", forState: UIControlState.Normal)
        titleButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 25.0)
        titleButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        titleButton.addTarget(self, action: "titlePressed:", forControlEvents: UIControlEvents.TouchUpInside)
        self.navigationItem.titleView = titleButton
        
        
        cartButton.setImage(UIImage(named: "shoppingCart"), forState: .Normal)
        cartButton.frame = CGRectMake(0, 0, 30, 30)
        cartButton.addTarget(self, action: "toCheckout:", forControlEvents: .TouchUpInside)
        let rightButton = UIBarButtonItem()
        rightButton.customView = cartButton
        self.navigationItem.rightBarButtonItem = rightButton
        
        self.createImages()
    }
    
    override func viewWillAppear(animated: Bool) {
        if (Order.items.count > 0) {
            cartButton.badgeString = String(Order.items.count)
        }
        else {
            cartButton.badgeString = nil
        }
    }
    
    func toCheckout(sender:UIButton) {
        let mapViewControllerObejct = self.storyboard?.instantiateViewControllerWithIdentifier("OrderSummaryVC") as? OrderSummaryViewController
        self.navigationController?.pushViewController(mapViewControllerObejct!, animated: true)
    }
    
    @IBAction func titlePressed(sender: UIButton) {
        print("Test")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func createImages() {
        SwiftSpinner.show("")
        let query = PFQuery(className: "Restaurants")
        query.addDescendingOrder("createdAt")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if let error = error {
                SwiftSpinner.hide()
                let alertController = UIAlertController(title:"Error", message: "\(error)", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            } else {
                SwiftSpinner.hide()
                var count:Int = 0
                for object in objects! {
                    print(object)
                    self.RestaurantArray.append(object)
                    let imageView = ZFRippleButton()
                    imageView.frame = CGRectMake(2, CGFloat(66 + 102*(count)), self.screenBounds.width-4, 100)
                    imageView.addTarget(self, action: "imageTapped:", forControlEvents: UIControlEvents.TouchUpInside)
                    imageView.setTitle(object.valueForKey("Name") as! String!, forState: UIControlState.Normal)
                    imageView.titleLabel!.font =  UIFont(name: "Helvetica Neue", size: 20)
                    imageView.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                    imageView.backgroundColor = UIColor(rgba: object.valueForKey("Color") as! String!)
                    self.view.addSubview(imageView)
                    imageView.tag = count
                    count++
                }
            }
        }
    }
    
    func back(sender: UIBarButtonItem) {
    //segue back
        print("BACK")
    }
    
    func imageTapped(sender: UIButton) {
        SwiftSpinner.show("")
        let query = PFQuery(className: self.RestaurantArray[sender.tag].valueForKey("ClassAccessName") as! String!)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if let error = error {
                SwiftSpinner.hide()
                let alertController = UIAlertController(title:"Error", message: "\(error)", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            } else {
                SwiftSpinner.hide()
                let mapViewControllerObejct = self.storyboard?.instantiateViewControllerWithIdentifier("MenuTableVC") as? MenuTableViewController
                mapViewControllerObejct?.ItemArray = objects
                Order.Restaurant = self.RestaurantArray[sender.tag]
                self.navigationController?.pushViewController(mapViewControllerObejct!, animated: true)
            }
        }
    }
    
    
    

}

