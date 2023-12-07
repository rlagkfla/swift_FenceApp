//
//  AlertService.swift
//  FenceApp
//
//  Created by t2023-m0073 on 11/19/23.
//

import UIKit

class AlertService {
    
    static var rootViewController: UIViewController? {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        let window = windowScene?.windows.first
        let rootViewController = window?.rootViewController
        return rootViewController
    }
    
    static func makeAlertWrittenByOthers(completion: @escaping () -> Void) {
        let alertController = UIAlertController()
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let reportAction = UIAlertAction(title: "신고하기", style: .destructive) { _ in
            completion()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(reportAction)
        
        rootViewController?.present(alertController, animated: true)
        
    }
    
    static func makeAlertWrittenByMe(completion: @escaping () -> Void) {
        let alertController = UIAlertController()
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let deleteAction = UIAlertAction(title: "삭제하기", style: .destructive) { _ in
            let deleteAlertController = UIAlertController(title: "삭제하기", message: "정말로 삭제하시겠습니까?", preferredStyle: .alert)
            completion()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        rootViewController?.present(alertController, animated: true)
    }
    
    func makeAlert2(completion: @escaping () -> Void ) -> UIAlertController {
        let alertController = UIAlertController(title: "삭제하기", message: "정말로 삭제하시겠습니까?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let deleteAction = UIAlertAction(title: "삭제하기", style: .destructive) { _ in
            completion()
        }
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        return alertController
    }
}
