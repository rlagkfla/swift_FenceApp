//
//  UIViewController+Ext.swift
//  FenceApp
//
//  Created by Woojun Lee on 11/23/23.
//

import UIKit
import SnapKit

extension UIViewController {
    func add(_ child: UIViewController, to containerView: UIView) {
        addChild(child)
        containerView.addSubview(child.view)
        child.view.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        child.didMove(toParent: self)
    }
    
    func remove() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
}
