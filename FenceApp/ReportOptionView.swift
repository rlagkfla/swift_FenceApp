//
//  ReportOptionView.swift
//  FenceApp
//
//  Created by t2023-m0073 on 11/13/23.
//

import UIKit
import SnapKit

class ReportOptionView: UIView {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 50
        
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        configureUI()
//        addGestureOnSelf()
    }
    
    var gesture: UITapGestureRecognizer!
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        self.isHidden = true
        self.backgroundColor = .systemGray.withAlphaComponent(0.4)
        configureTableView()
        
    }
    
    private func configureTableView() {
        addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(100)
            $0.height.equalTo(100)
        }
    }
    
    private func addGestureOnSelf() {
        gesture = UITapGestureRecognizer(target: self, action: nil)
        addGestureRecognizer(gesture)
        gesture.delegate = self
    }
}

extension ReportOptionView: UIGestureRecognizerDelegate {

    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let location = gestureRecognizer.location(in: self)
        
        if tableView.frame.contains(location) {
            
            return false
        } else {
            
            self.isHidden = true
            return false
        }
        
        
    }
}
