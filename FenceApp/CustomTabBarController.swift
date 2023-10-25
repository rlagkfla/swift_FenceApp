//
//  CustomTabBarController.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/16/23.
//

import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {

    let controllers: [UIViewController]
    
    lazy var cameraButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        button.setImage(UIImage(systemName: "camera"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = UIColor(hexCode: "5DDFDE")
        button.layer.cornerRadius = 20
        button.isUserInteractionEnabled = true
        button.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        configureTabBarControllers()
        configureCameraButton()
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
        
        let dummyTabBarItem = UITabBarItem(title: nil, image: nil, tag: 2)
        controllers[2].tabBarItem = dummyTabBarItem
        
        let chatTabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "message"), tag: 3)
        chatTabBarItem.selectedImage = UIImage(systemName: "message.fill")
        controllers[3].tabBarItem = chatTabBarItem
        
        let myInfoTabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "person"), tag: 4)
        myInfoTabBarItem.selectedImage = UIImage(systemName: "person.fill")
        controllers[4].tabBarItem = myInfoTabBarItem
    
        self.viewControllers = controllers
          
        self.tabBar.barTintColor = UIColor(hexCode: "5DDFDE")
        self.tabBar.unselectedItemTintColor = .black
    }
    
    func configureCameraButton() {
        self.tabBar.addSubview(cameraButton)
        cameraButton.frame = CGRect(x: Int(self.tabBar.bounds.width / 2) - 25, y: -20, width: 50, height: 50)
    }
    
    @objc func cameraButtonTapped() {
        print(#function)
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController == controllers[2] {
            return false
        }
        return true
    }
}
