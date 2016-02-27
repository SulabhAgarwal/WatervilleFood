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

class MainMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let screenBounds = UIScreen.mainScreen().bounds
    var array:[PFObject]?
    var RestaurantArray:[PFObject]! = [PFObject]()
    let cartButton:MIBadgeButton = MIBadgeButton()
    let keyView:UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "Main"
        
        let titleButton: UIButton = UIButton(frame: CGRectMake(0,0,20,32))
        titleButton.setTitle("Restaurants", forState: UIControlState.Normal)
        titleButton.titleLabel?.font = UIFont(name: "Futura", size: 25.0)
        titleButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        self.navigationItem.titleView = titleButton
        
        
        keyView.frame = CGRectMake(2, 66, screenBounds.width-4, 60)
        keyView.layer.borderWidth = 2
        self.keyView.delegate = self
        self.keyView.dataSource = self
        keyView.scrollEnabled = false
        keyView.registerNib(UINib(nibName: "KeyImage", bundle: nil), forCellReuseIdentifier: "KeyImage")
        keyView.contentInset = UIEdgeInsets(top: -62, left: 0, bottom: 0, right: 0)
        self.view.addSubview(keyView)
        
        
        
        self.createImages()
    }
    
    override func viewWillAppear(animated: Bool) {
        cartButton.setImage(UIImage(named: "shoppingCart"), forState: .Normal)
        cartButton.frame = CGRectMake(0, 0, 30, 30)
        cartButton.addTarget(self, action: "toCheckout:", forControlEvents: .TouchUpInside)
        let rightButton = UIBarButtonItem()
        rightButton.customView = cartButton
        self.navigationItem.rightBarButtonItem = rightButton
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
                    imageView.frame = CGRectMake(2, CGFloat(128 + 102*(count)), self.screenBounds.width-4, 100)
                    imageView.addTarget(self, action: "imageTapped:", forControlEvents: UIControlEvents.TouchUpInside)
                    imageView.setTitle(object.valueForKey("Name") as! String!, forState: UIControlState.Normal)
                    imageView.titleLabel!.font =  UIFont(name: "Helvetica Neue", size: 20)
                    imageView.titleEdgeInsets = UIEdgeInsetsMake(-40, 0, 0, 0)
                    imageView.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                    imageView.backgroundColor = UIColor(rgba: object.valueForKey("Color") as! String!)
                    self.view.addSubview(imageView)
                    imageView.tag = count
                    
                    let openIconView = UIImageView()
                    openIconView.frame = CGRectMake(imageView.bounds.width/2+10, imageView.bounds.height - 40, 30, 30)
                    openIconView.image = UIImage(named: "signWhite")
                    imageView.addSubview(openIconView)
                    
                    let deliveryIconView = UIImageView()
                    deliveryIconView.frame = CGRectMake(imageView.bounds.width/2-40, imageView.bounds.height - 40, 30, 30)
                    deliveryIconView.image = UIImage(named: "transportWhite")
                    imageView.addSubview(deliveryIconView)
                    
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
                if (Order.Restaurant != self.RestaurantArray[sender.tag] && Order.Restaurant != nil) {
                    let alertview = JSSAlertView().danger(self, title: "Error", text: "Can only order from one restaurant at a time. Delete the items in your cart to continue with this restaurant.")
                    alertview.setTitleFont("Futura")
                    alertview.setTextFont("Futura")
                    alertview.setButtonFont("Futura")
                    return
                }
                let mapViewControllerObejct = self.storyboard?.instantiateViewControllerWithIdentifier("MenuTableVC") as? MenuTableViewController
                mapViewControllerObejct?.ItemArray = objects
                mapViewControllerObejct!.Restaurant = self.RestaurantArray[sender.tag]
                self.navigationController?.pushViewController(mapViewControllerObejct!, animated: true)
            }
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        print("TEST")
        return "Key"
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("KeyImage", forIndexPath: indexPath) as! KeyImage
        cell.KeyIconOne.image = UIImage(named: "transport")
        cell.KeyIconTwo.image = UIImage(named: "sign")
        cell.KeyLabelOne.text = "Delivery"
        cell.KeyLabelTwo.text = "Open now"
        print("\n\nCELL INSTANTIATED")
        
        return cell
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    

}

