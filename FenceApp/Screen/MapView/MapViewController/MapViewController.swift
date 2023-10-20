//
//  MapViewController.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/16/23.
//

import UIKit
import FirebaseAuth


class MapViewController: UIViewController {
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    private let userInfoService = UserInfoService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Task { await fetchAndDisplayUserEmail() }
        view.backgroundColor = .yellow
        setupEmailLabel()
        
    }
    
    private func setupEmailLabel() {
        view.addSubview(emailLabel)
        emailLabel
            .centerX()
            .centerY()
    }
    
    private func fetchAndDisplayUserEmail() async {
        guard let user = Auth.auth().currentUser else { print("Failed \(#function)"); return}
        
        do {
            guard let userEmail =
                    try await userInfoService.fetchUserEmail(for: user.uid) else {print("Failed \(#function) - Email not found");return}
            emailLabel.text = userEmail
            
        } catch {
            print(error.localizedDescription)
        }
    }
}
