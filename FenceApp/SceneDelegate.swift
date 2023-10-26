//
//  SceneDelegate.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/16/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    let firstTabNavigationController = UINavigationController()
    let secondTabNavigationController = UINavigationController()
    let thirdTabNavigationController = UINavigationController()
    let fourthTabNavigationController = UINavigationController()
    
    let locationManager = LocationManager()
    let firebaseFoundService = FirebaseFoundService()
    let firebaseLostCommentService = FirebaseLostCommentService()
    
    lazy var firebaseAuthService = FirebaseAuthService(firebaseUserService: firebaseUserService, firebaseLostService: firebaseLostService, firebaseLostCommentService: firebaseLostCommentService, firebaseFoundService: firebaseFoundService)
    
    lazy var firebaseUserService = FirebaseUserService(firebaseLostService: firebaseLostService, firebaseLostCommentService: firebaseLostCommentService)
    lazy var firebaseLostService = FirebaseLostService(firebaseLostCommentService: firebaseLostCommentService)
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        Task {
            do {
//                firebaseUserService.listenToUpdateOn(userIdentifier: "045RhOisSFgjp0AjR2DusTpDsyb2") { result in
//                    switch result {
//                    case .failure(let error):
//                        print(error)
//                    case .success(let userResponseDTO):
//                        print(userResponseDTO.email, "!!!!!!!")
//                       
//                       
//                    }
//                }
                try await firebaseAuthService.signInUser(email: "aaa@gmail.com", password: "123456")
                let a = firebaseAuthService.checkIfUserLoggedIn()
                print(a)
            } catch {
                print(error, "@@@@@@@@")
            }
        }
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = makeTabbarController()
        window?.makeKeyAndVisible()
        
        setNavigationControllers()
    }
    
    private func setNavigationControllers() {
        firstTabNavigationController.viewControllers = [makeMapViewVC()]
        secondTabNavigationController.viewControllers = [makeLostViewVC()]
        thirdTabNavigationController.viewControllers = [makeChatViewController()]
        fourthTabNavigationController.viewControllers = [makeMyInfoViewController()]
    }
    
    private func makeTabbarController() -> CustomTabBarController {
        let TabbarController = CustomTabBarController(controllers: [firstTabNavigationController, secondTabNavigationController, makeDummyViewController(), thirdTabNavigationController, fourthTabNavigationController], locationManager: locationManager, firebaseFoundSerivce: firebaseFoundService)
        
        return TabbarController
    }
    
    private func makeMapViewVC() -> MapViewController {
        
        let vc = MapViewController(firebaseLostService: firebaseLostService, firebaseFoundService: firebaseFoundService, locationManager: locationManager)
        vc.filterTapped = {
            let viewController = CustomModalViewController()
            vc.present(viewController, animated: true)
        }
        return vc
    }
    
    private func makeLostViewVC() -> LostListViewController {
        let vc = LostListViewController(fireBaseLostService: firebaseLostService, firebaseLostCommentService: firebaseLostCommentService, firebaseAuthService: firebaseAuthService, firebaseUserService: firebaseUserService)
        return vc
    }
    
    private func makeDummyViewController() -> UIViewController {
        let vc = UIViewController()
        return vc
    }
    
    private func makeChatViewController() -> ChatViewController {
        let vc = ChatViewController(firebaseFoundService: firebaseFoundService)
        return vc
    }
    
    private func makeMyInfoViewController() -> MyInfoViewController {
        let vc = MyInfoViewController()
        return vc
    }
}
