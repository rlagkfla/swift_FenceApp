//
//  MainViewController.swift
//  FenceApp
//
//  Created by Woojun Lee on 11/22/23.
//

import UIKit

class MainViewController<V: UIView>: UIViewController {
    
    lazy var mainView = V()
    
    override func loadView() {
        self.view = mainView
        
    }
}
