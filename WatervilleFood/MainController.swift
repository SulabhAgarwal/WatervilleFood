//
//  MainController.swift
//  WatervilleFood
//
//  Created by Daniel Vogel on 1/12/16.
//  Copyright © 2016 Daniel Vogel. All rights reserved.
//

import Foundation
import UIKit

class MainController: UINavigationController {
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.createNavBar()
//        let myLabel = UILabel(frame: CGRectMake(0,0, 100,100))
//        myLabel.text = "Hello World"
//        self.view.addSubview(myLabel)
        let mainView = MainMenuViewController()
        let menuView = MenuTableViewController()
        let optionsView = OptionsTableViewController()
        self.viewControllers = [mainView]
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
}