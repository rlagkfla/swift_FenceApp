//
//  SceneDelegate.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/16/23.
//

import UIKit
import FirebaseAuth


class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    let firebaseImageUploadService = FirebaseImageUploadService()
    let imageLoader = ImageLoader()
    let firebaseAuthService = FirebaseAuthService()
    let firstTabNavigationController = UINavigationController()
    let secondTabNavigationController = UINavigationController()
    let thirdTabNavigationController = UINavigationController()
    let fourthTabNavigationController = UINavigationController()
    
    
    lazy var firebaseFoundService = FirebaseFoundService(firebaseImageUploadService: firebaseImageUploadService)
    lazy var firebaseUserService = FirebaseUserService(firebaseImageUploader: firebaseImageUploadService, firebaseLostService: firebaseLostService, firebaseLostCommentService: firebaseLostCommentService)
    lazy var firebaseLostService = FirebaseLostService(firebaseImageUploader: firebaseImageUploadService)
    lazy var firebaseLostCommentService = FirebaseLostCommentService(firebaseImageUploadService: firebaseImageUploadService)
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        Task {
            do {

                try await firebaseUserService.editUser(userResponseDTO: UserResponseDTO(email: "q", profileImageURL: "##", identifier: "user1", nickname: "##"))
                


            } catch {
                print(error, "@@@@@@@")
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
        let TabbarController = CustomTabBarController(controllers: [firstTabNavigationController, secondTabNavigationController, makeCameraViewController(), thirdTabNavigationController, fourthTabNavigationController])
        
        return TabbarController
    }
    
    private func makeMapViewVC() -> MapViewController {
        let vc = MapViewController(imageLoader: imageLoader)
        
        return vc
    }
    
    private func makeLostViewVC() -> LostListViewController {
        let vc = LostListViewController()
        return vc
    }
    
    private func makeCameraViewController() -> CameraViewController {
        let vc = CameraViewController()
        
        return vc
    }

    private func makeChatViewController() -> ChatViewController {
        let vc = ChatViewController()
        return vc
    }
    
    private func makeMyInfoViewController() -> MyInfoViewController {
        let vc = MyInfoViewController()
        return vc
    }
    
  


}

