//
//  SceneDelegate.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/16/23.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    let firebaseImageUploadService = FirebaseImageUploadService()
    let imageLoader = ImageLoader()
    let firebaseAuthService = FirebaseAuthService()
    let firstTabNavigationController = UINavigationController()
    let secondTabNavigationController = UINavigationController()
    let thirdTabNavigationController = UINavigationController()
    let fourthTabNavigationController = UINavigationController()
    
    let userResponseDTOMapper = UserResponseDTOMapper()
    let lostResponseDTOMapper = LostResponseDTOMapper()
    let commentResponseDTOMapper = CommentResponseDTOMapper()
    let foundResponseDTOMapper = FoundResponseDTOMapper()
    
    lazy var firebaseFoundService = FirebaseFoundService(foundResponseDTOMapper: foundResponseDTOMapper)
    lazy var firebaseUserService = FirebaseUserService(firebaseLostService: firebaseLostService, firebaseLostCommentService: firebaseLostCommentService, userResponseDTOMapper: userResponseDTOMapper)
    lazy var firebaseLostService = FirebaseLostService(lostResponseDTOMapper: lostResponseDTOMapper, firebaseLostCommentService: firebaseLostCommentService)
    lazy var firebaseLostCommentService = FirebaseLostCommentService(commentResponseDTOMapper: commentResponseDTOMapper)
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        Task {
            do {

                
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
