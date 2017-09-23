//
//  CustomNavigationController.swift
//  DropMusic
//
//  Created by Angel Contreras on 9/18/17.
//  Copyright © 2017 Angel Contreras. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController {
   
    override var navigationBar: UINavigationBar {
        let navBar = UINavigationBar()
        navBar.shadowImage = nil
        return navBar
    }
    
}
