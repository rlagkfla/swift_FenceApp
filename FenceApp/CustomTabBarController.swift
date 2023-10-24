//
//  CustomTabBarController.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/16/23.
//

import UIKit

class CustomTabBarController: UITabBarController {

    let controllers: [UIViewController]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTabBarControllers()
    }
    
    init(controllers: [UIViewController]) {
        self.controllers = controllers
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTabBarControllers() {

        let mapTabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "map"), tag: 0)
        mapTabBarItem.selectedImage = UIImage(systemName: "map.fill")
        controllers[0].tabBarItem = mapTabBarItem
        
        let lostListTabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "menucard"), tag: 1)
        lostListTabBarItem.selectedImage = UIImage(systemName: "menucard.fill")
        controllers[1].tabBarItem = lostListTabBarItem
        
        let cameraTabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "camera"), tag: 2)
        cameraTabBarItem.selectedImage = UIImage(systemName: "camera.fill")
        controllers[2].tabBarItem = cameraTabBarItem
        
        let chatTabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "message"), tag: 3)
        chatTabBarItem.selectedImage = UIImage(systemName: "message.fill")
        controllers[3].tabBarItem = chatTabBarItem
        
        let myInfoTabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person"), tag: 4)
        myInfoTabBarItem.selectedImage = UIImage(systemName: "person.fill")
        controllers[4].tabBarItem = myInfoTabBarItem
    
        self.viewControllers = controllers
          
        self.tabBar.barTintColor = UIColor(red: 93, green: 223, blue: 222, alpha: 1)
        self.tabBar.unselectedItemTintColor = .gray
    }
}
