//
//  SceneDelegate.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/16/23.
//

import UIKit
import FirebaseFirestore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = LoginViewController()
        window?.makeKeyAndVisible()
    }
}


//Task {
//    do {
//                        var lostWithDocument: LostWithDocument?
//                        var lostResponseArray: [LostResponseDTO] = []
//        
//                        lostWithDocument = try await firebaseLostService.fetchLostsWithPagination(int: 3)
//        
//                        lostResponseArray.append(contentsOf: lostWithDocument!.lostResponseDTOs)
//        
//        
//        
//                        lostResponseArray.forEach { lostResponseDTO in
//                            print(lostResponseDTO.lostIdentifier, "(((((")
//                        }
//                        lostWithDocument = try await firebaseLostService.fetchLostsWithPagination(int: 3, lastDocument: lostWithDocument!.lastDocument)
//        
//                        lostResponseArray.append(contentsOf: lostWithDocument!.lostResponseDTOs)
//        
//                        lostResponseArray.forEach { lostResponseDTO in
//                            print(lostResponseDTO.lostIdentifier, "(((((")
//                        }
//                        firebaseUserService.listenToUpdateOn(userIdentifier: "045RhOisSFgjp0AjR2DusTpDsyb2") { result in
//                            switch result {
//                            case .failure(let error):
//                                print(error)
//                            case .success(let userResponseDTO):
//                                print(userResponseDTO.email, "!!!!!!!")
//        
//        
//                            }
//                        }
//                        try await firebaseAuthService.signInUser(email: "aaa@gmail.com", password: "123456")
//                        let a = firebaseAuthService.checkIfUserLoggedIn()
//                        print(a)
//        
//                var foundWithDocument: FoundWithDocument?
//                var foundResponseArray: [FoundResponseDTO] = []
//
//                foundWithDocument = try await firebaseFoundService.fetchFoundsWithPagination(int: 3)
//
//                foundResponseArray.append(contentsOf: foundWithDocument!.foundResponseDTOs)
//
//                foundResponseArray.forEach { foundResponseDTO in
//                    print(foundResponseDTO.foundIdentifier, "((((((")
//                }
//
//                foundWithDocument = try await firebaseFoundService.fetchFoundsWithPagination(int: 3, lastDocument: foundWithDocument!.lastDocument)
//
//                foundResponseArray.append(contentsOf: foundWithDocument!.foundResponseDTOs)
//
//                foundResponseArray.forEach { foundResponseDTO in
//                    print(foundResponseDTO.foundIdentifier, "(((((")
//                }
//        
//        
//        
//    } catch {
//        print(error, "@@@@@@@@")
//    }
//}
