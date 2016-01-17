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

struct Order {
    //[["<order item>","[<options>]","price"], ["<order item>","[<options>]","price"]]
    static var items:[[AnyObject]] = [["Danny Special", [["Stuff", ["Bless Up"]]], 69.69]]
    static var tax:Double = 1.00
    static var tip:Double = 1.00
    static var Restaurant:PFObject!
}

class MainMenuViewController: UIViewController {

    let screenBounds = UIScreen.mainScreen().bounds
    var array:[PFObject]?
    let COLOR_PALLETTE:[String] = ["#0ccca0", "#e708a6", "#11a2c1", "#20ec00", "#13ebfd"]
    var RestaurantArray:[PFObject]! = [PFObject]()
    
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
        
        let cartButton = UIButton()
        cartButton.setImage(UIImage(named: "shoppingCart"), forState: .Normal)
        cartButton.frame = CGRectMake(0, 0, 30, 30)
        cartButton.addTarget(self, action: "toCheckout:", forControlEvents: .TouchUpInside)
        let rightButton = UIBarButtonItem()
        rightButton.customView = cartButton
        self.navigationItem.rightBarButtonItem = rightButton
        
        
        
        self.createImages()
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
                    self.RestaurantArray.append(object)
                    let imageView = UIButton()
                    imageView.frame = CGRectMake(2, CGFloat(66 + 102*(count)), self.screenBounds.width-4, 100)
                    imageView.addTarget(self, action: "imageTapped:", forControlEvents: UIControlEvents.TouchUpInside)
                    imageView.setTitle(object.valueForKey("Name") as! String!, forState: UIControlState.Normal)
                    imageView.titleLabel!.font =  UIFont(name: "Helvetica Neue", size: 20)
                    imageView.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                    imageView.backgroundColor = UIColor(rgba: self.COLOR_PALLETTE[count])
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

