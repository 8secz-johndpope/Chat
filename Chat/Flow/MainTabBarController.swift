//
//  MainTabBarController.swift
//  Chat
//
//  Created by Vadim Koronchik on 3/30/19.
//  Copyright © 2019 Vadim Koronchik. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}

extension MainTabBarController {
    
    static func create() -> MainTabBarController {
        let tabBarController = R.storyboard.main.mainTabBarController()!
        return tabBarController
    }
    
}
