//
//  ViewController.swift
//  WatervilleFood
//
//  Created by Daniel Vogel on 1/10/16.
//  Copyright © 2016 Daniel Vogel. All rights reserved.
//

import UIKit
import Parse

class MainMenuViewController: UIViewController {

    let screenBounds = UIScreen.mainScreen().bounds
    var array:[PFObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.createNavBar()
        self.createImages()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createNavBar() {
        // Create the navigation bar
        let navigationBar = UINavigationBar(frame: CGRectMake(0, 20, self.view.frame.size.width, 44)) // Offset by 20 pixels vertically to take the status bar into account
        
        navigationBar.backgroundColor = UIColor.whiteColor()
        //navigationBar.delegate =
        
        // Create a navigation item with a title
        let navigationItem = UINavigationItem()
        navigationItem.title = "Waterville Food"
        
        // Create left and right button for navigation item
        let backButton = UIButton()
        backButton.setImage(UIImage(named: "backButton"), forState: .Normal)
        backButton.frame = CGRectMake(0, 0, 30, 30)
        backButton.addTarget(self, action: "back:", forControlEvents: .TouchUpInside)
        let leftButton = UIBarButtonItem()
        leftButton.customView = backButton
        
        let cartButton = UIButton()
        cartButton.setImage(UIImage(named: "shoppingCart"), forState: .Normal)
        cartButton.frame = CGRectMake(0, 0, 30, 30)
        cartButton.addTarget(self, action: "back:", forControlEvents: .TouchUpInside)
        let rightButton = UIBarButtonItem()
        rightButton.customView = cartButton
        
        // Create two buttons for the navigation item
        navigationItem.leftBarButtonItem = leftButton
        navigationItem.rightBarButtonItem = rightButton
        
        // Assign the navigation item to the navigation bar
        navigationBar.items = [navigationItem]
        
        // Make the navigation bar a subview of the current view controller
        self.view.addSubview(navigationBar)
    }
    
    func createImages() {
        let PTimage = UIImage(named: "PadThaiToo")
        let PTimageView = UIButton()
        PTimageView.frame = CGRect(x: 2, y: 66, width: screenBounds.width/2-4, height: 150)
        PTimageView.setImage(PTimage, forState: .Normal)
        PTimageView.addTarget(self, action: "imageTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(PTimageView)
        PTimageView.tag = 1

        
        let WHOPimage = UIImage(named: "WHOP")
        let WHOPimageView = UIButton()
        WHOPimageView.frame = CGRect(x: screenBounds.width/2 + 2, y: 66, width: screenBounds.width/2-4, height: 150)
        WHOPimageView.setImage(WHOPimage, forState: .Normal)
        WHOPimageView.addTarget(self, action: "imageTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        WHOPimageView.tag = 2
        view.addSubview(WHOPimageView)

        
        let GCimage = UIImage(named: "GrandCentral")
        let GCimageView = UIButton()
        GCimageView.frame = CGRect(x: 2, y: 218, width: screenBounds.width/2-4, height: 150)
        GCimageView.setImage(GCimage, forState: .Normal)
        GCimageView.addTarget(self, action: "imageTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        GCimageView.tag = 3
        view.addSubview(GCimageView)
        
        let DEimage = UIImage(named: "DancingElephant")
        let DEimageView = UIButton()
        DEimageView.frame = CGRect(x: screenBounds.width/2 + 2, y: 218, width: screenBounds.width/2-4, height: 150)
        DEimageView.setImage(DEimage, forState: .Normal)
        DEimageView.addTarget(self, action: "imageTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        DEimageView.tag = 4
        view.addSubview(DEimageView)

    }
    
    func back(sender: UIBarButtonItem) {
    //segue back
        print("BACK")
    }
    
    func imageTapped(sender: UIButton) {
        var restaurant : String!
        switch sender.tag {
        case 1:
            restaurant = "PadThaiToo"
        case 2:
            restaurant = "WHOP"
        case 3:
            restaurant = "GrandCentral"
        case 4:
            restaurant = "DancingElephant"
        default:
            let alertController = UIAlertController(title:"Error", message: "Cannot retrieve restaurant information", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
    
        
        
        let query = PFQuery(className: restaurant)
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if let error = error {
                let alertController = UIAlertController(title:"Error", message: "\(error)", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            } else {
                self.array = objects
                self.performSegueWithIdentifier("MainToMenuOptions", sender: sender)
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
            let detailVC = segue.destinationViewController as! MenuTableViewController;
            print(self.array)
            detailVC.ItemArray = self.array
    }

}

