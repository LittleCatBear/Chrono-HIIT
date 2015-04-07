//
//  CustomTabBarViewController.swift
//  Chrono HIIT
//
//  Created by Julie Huguet on 07/04/2015.
//  Copyright (c) 2015 Shokunin-Software. All rights reserved.
//

import Foundation
import UIKit

class CustomTabBarViewController: UITabBarController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBar.barTintColor = UIColor.blackColor()
        self.tabBar.tintColor = UIColor(red: 0.082, green: 0.647, blue: 0.859, alpha: 1.0)
    }
    
}