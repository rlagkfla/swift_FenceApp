//
//  FoundModalViewController.swift
//  FenceApp
//
//  Created by Woojun Lee on 11/5/23.
//

import UIKit

class FoundModalViewController: UIViewController {
    
    
    //MARK: - Properties
    
    let found: Found
    
    let mainView = FoundModalMainView()
    
    //MARK: - Lifecycle
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSelf()
        mainView.configureModal(urlString: found.imageURL, date: found.date)
    }
    
    init(found: Found) {
        self.found = found
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    //MARK: - Helpers
    
    private func setSelf() {
        self.modalTransitionStyle = .coverVertical
        self.modalPresentationStyle = .pageSheet
        if let sheet = self.sheetPresentationController {
            sheet.detents = [.medium()]
            
        }
    }
    
    
        
    
    //MARK: - UI

}
