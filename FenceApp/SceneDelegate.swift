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

    let navigationController = UINavigationController()
    let firebaseAuthService = FirebaseAuthService()
    let firebaseUserService = FirebaseUserService()
    let firebaseLostService = FirebaseLostService()
    let firebaseFoundService = FirebaseFoundService()
    let firebaseLostCommentService = FirebaseLostCommentService()
    let firebaseImageUploader = FirebaseImageUploader()
    let imageLoader = ImageLoader()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        Task {
            do {
                let a = try await firebaseImageUploader.uploadImage(image: UIImage(systemName: "house")!)
                print(a)
//                try await firebaseFoundService.createFound(found: Found.dummyFound[0])
//                try await firebaseLostService.createLost(lost: Lost.dummyLost[0])
//                try await firebaseLostCommentService.createComment(lostIdentifier: "a", comment: Comment.dummyComment[0])
//                let authDataResult = try await firebaseAuthService.signUpUser(email: "bbb@gmail.com", password: "123456")
//                try await firebaseUserService.createUser(nickname: "pingping", profileImageURL: "b", authDataResult: authDataResult)
            } catch {
                print(error, "@@@@@@@")
            }
        }
    
        
        
          // ...
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        
        let tabbarController = makeTabbarController()
        navigationController.viewControllers = [tabbarController]
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
    }
    
    
    
    func makeTabbarController() -> CustomTabBarController {
        let TabbarController = CustomTabBarController(controllers: [makeMapViewVC(), makeLostViewVC(), makeCameraViewController(), makeChatViewController(), makeMyInfoViewController()])
        
        return TabbarController
    }
    
    func makeMapViewVC() -> MapViewController {
        let vc = MapViewController(imageLoader: imageLoader)
        
        return vc
    }
    
    func makeLostViewVC() -> LostListViewController {
        let vc = LostListViewController()
        return vc
    }
    
    func makeCameraViewController() -> CameraViewController {
        let vc = CameraViewController()
        
        return vc
    }

    func makeChatViewController() -> ChatViewController {
        let vc = ChatViewController()
        return vc
    }
    
    func makeMyInfoViewController() -> MyInfoViewController {
        let vc = MyInfoViewController()
        return vc
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

