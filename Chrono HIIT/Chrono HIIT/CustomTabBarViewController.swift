//
//  CustomTabBarViewController.swift
//  Chrono HIIT
//
//  Created by Julie Huguet on 07/04/2015.
//  Copyright (c) 2015 Shokunin-Software. All rights reserved.
//

import Foundation
import UIKit

class CustomTabBarViewController: UITabBarController, UITabBarControllerDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.barTintColor = UIColor.blackColor()
        self.tabBar.translucent = false
        self.tabBar.tintColor = UIColor(red: 0.082, green: 0.647, blue: 0.859, alpha: 1.0)
    
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        if(isRegistered){
            self.tabBar.tintColor = UIColor(red: 0.75, green: 0.118, blue: 0.176, alpha: 1.0)
        } else{
            self.tabBar.tintColor = UIColor(red: 0.082, green: 0.647, blue: 0.859, alpha: 1.0)
        }
    }

}