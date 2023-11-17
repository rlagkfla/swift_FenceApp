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
    
    let firstTabNavigationController = UINavigationController()
    let secondTabNavigationController = UINavigationController()
    let thirdTabNavigationController = UINavigationController()
    let fourthTabNavigationController = UINavigationController()
    
    let locationManager = LocationManager()
    lazy var firebaseFoundService = FirebaseFoundService(locationManager: locationManager)
    let firebaseLostCommentService = FirebaseLostCommentService()
    
    lazy var firebaseAuthService = FirebaseAuthService(firebaseUserService: firebaseUserService, firebaseLostService: firebaseLostService, firebaseLostCommentService: firebaseLostCommentService, firebaseFoundService: firebaseFoundService)
    
    lazy var firebaseUserService = FirebaseUserService(firebaseLostService: firebaseLostService, firebaseLostCommentService: firebaseLostCommentService, firebaseFoundService: firebaseFoundService)
    lazy var firebaseLostService = FirebaseLostService(firebaseLostCommentService: firebaseLostCommentService, locationManager: locationManager)
    lazy var firebaseCloudMessaing = FirebaseCloudMessaging()
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        
        window?.makeKeyAndVisible()
        
        
        Task {
            
            do {
                
                try await checkUserLoggedIn()
                
            } catch {
                
                try firebaseAuthService.signOutUser()
                print(error)
                window?.rootViewController = makeLoginVC()
            }
        }
    }
    
    
    private func checkUserLoggedIn() async throws {
        
        let isUserLoggedIn = firebaseAuthService.checkIfUserLoggedIn()
        
        if isUserLoggedIn && locationManager.fetchStatus() == true {
            
            let userIdentifier = try firebaseAuthService.getCurrentUser().uid
            
            let userResponseDTO = try await firebaseUserService.fetchUser(userIdentifier: userIdentifier)
            
            let user = UserResponseDTOMapper.makeFBUser(from: userResponseDTO)
            
            CurrentUserInfo.shared.currentUser = user
            
            window?.rootViewController = makeTabbarController()
            
            
        } else {
            try firebaseAuthService.signOutUser()
            window?.rootViewController = makeLoginVC()
        }
    }
    
    
    private func setNavigationControllers() {
        firstTabNavigationController.viewControllers = [makeMapViewVC()]
        secondTabNavigationController.viewControllers = [makeLostViewVC()]
        thirdTabNavigationController.viewControllers = [MessageRoomViewController()]
        fourthTabNavigationController.viewControllers = [makeMyInfoViewController()]
    }
    
  
    
    private func makeTabbarController() -> CustomTabBarController {
        
        setNavigationControllers()
        
        let TabbarController = CustomTabBarController(controllers: [firstTabNavigationController, secondTabNavigationController, makeDummyViewController(), thirdTabNavigationController, fourthTabNavigationController], locationManager: locationManager, firebaseFoundSerivce: firebaseFoundService)
        
        TabbarController.finishUploadingFound = { [unowned self] missingType in
            
            let displayedMapViewController = (firstTabNavigationController.viewControllers.first as? MapViewController)
            
            displayedMapViewController?.changeIndexAndPerformAPIThenSetPins(missingType: missingType)
            
        }
        
        return TabbarController
    }
    
    
    private func makeMapViewVC() -> MapViewController {
        
        let mapViewController = MapViewController(firebaseLostService: firebaseLostService, firebaseFoundService: firebaseFoundService, locationManager: locationManager)
        
        mapViewController.filterTapped = { filterModel in
            
            let filterViewController = CustomFilterModalViewController(filterModel: filterModel)
            
            filterViewController.delegate = mapViewController
            
            mapViewController.present(filterViewController, animated: true)
            
        }
        
        mapViewController.annotationViewTapped = { [unowned self] pinable in
            
            
            
            let modalViewController = pinable is Lost ? makeLostModalVC(lost: pinable as! Lost) : makeFoundModalVC(found: pinable as! Found)
            
            mapViewController.present(modalViewController, animated: true)
        }
        
        return mapViewController
    }
    
    
    private func makeLostModalVC(lost: Lost) -> LostModalViewController {
        
        let lostModalViewController = LostModalViewController(lost: lost)
        
        lostModalViewController.transitToDetailVC = { [unowned self, weak lostModalViewController] lost in
            
            guard let lostModalViewController else { return }
            
            let detailViewController = makeDetailVC(lostIdentifier: lost.lostIdentifier, sender: lostModalViewController)
            
            lostModalViewController.dismiss(animated: true)
            
            firstTabNavigationController.pushViewController(detailViewController, animated: true)
            
        }
        
        return lostModalViewController
    }
    
    
    private func makeFoundModalVC(found: Found) -> FoundModalViewController {
        
        let foundModalViewController = FoundModalViewController(found: found)
        return foundModalViewController
    }
    
    
    private func makeLoginVC() -> LoginViewController {
        
        let vc = LoginViewController(firebaseAuthService: firebaseAuthService, firebaseUserService: firebaseUserService, locationManager: locationManager) { [unowned self] in
        
            window?.rootViewController = makeTabbarController()
        }
        
        return vc
    }
    
    
    private func makeDetailVC(lostIdentifier: String, sender viewController: UIViewController) -> DetailViewController {
        let detailViewController = DetailViewController(firebaseCommentService: firebaseLostCommentService, firebaseLostService: firebaseLostService, locationManager: locationManager, lostIdentifier: lostIdentifier, firebaseUserService: firebaseUserService)
        
        detailViewController.pushToCommentVC = { [unowned self, weak detailViewController] lost in
            
            guard let detailViewController else { return }
          
            let commentCollectionVC = makeCommentCollectionViewController(lost: lost)
            commentCollectionVC.delegate = detailViewController
            
            detailViewController.navigationController?.pushViewController(commentCollectionVC, animated: true)
        }
        
        detailViewController.hidesBottomBarWhenPushed = true
        
        detailViewController.onMoveToChatting = { [weak self] userResponseDTO in
            self?.presentMessageViewController(with: userResponseDTO)
        }

        return detailViewController
    }
    
    func presentMessageViewController(with lost: Lost) {

        let senderUserIdentifier = CurrentUserInfo.shared.currentUser?.userIdentifier ?? ""

        let messageViewModel = MessageViewModel(lost: lost, currentUser: CurrentUserInfo.shared)
        let messageVC = MessageViewController(viewModel: messageViewModel)
        
        if let rootViewController = window?.rootViewController {
            rootViewController.present(messageVC, animated: true)
        }
    }


    
    private func makeLostViewVC() -> LostListViewController {
        
        let lostListViewController = LostListViewController(fireBaseLostService: firebaseLostService)
        
        lostListViewController.lostCellTapped = { [ unowned self, weak lostListViewController ] lost in
            
            guard let lostListViewController else { return }
            
            let detailViewController = makeDetailVC(lostIdentifier: lost.lostIdentifier, sender: lostListViewController)
            
            lostListViewController.navigationController?.pushViewController(detailViewController, animated: true)
            
        }
        
        lostListViewController.plusButtonTapped = { [unowned self] in
            
            let enrollViewController = makeEnrollViewVC()
            
            enrollViewController.isEdited = false
            
            enrollViewController.hidesBottomBarWhenPushed = true
            
            enrollViewController.delegate = lostListViewController
            
            secondTabNavigationController.pushViewController(enrollViewController, animated: true)
        }
        
        lostListViewController.filterTapped = { filterModel in
            let filterViewController = CustomFilterModalViewController(filterModel: filterModel)
            
            filterViewController.delegate = lostListViewController
            
            lostListViewController.present(filterViewController, animated: true)
            
        }
        
        return lostListViewController
    }
    
    
    private func makeEnrollViewVC() -> EnrollViewController {
        let vc = EnrollViewController(firebaseLostService: firebaseLostService, locationManager: locationManager)
        
        vc.finishUploadingLost = { [unowned self] missingType in
            
            let displayedMapViewController = (firstTabNavigationController.viewControllers.first as? MapViewController)
            
            displayedMapViewController?.changeIndexAndPerformAPIThenSetPins(missingType: missingType)
            
            
        }
        
        return vc
    }
    
    
    private func makeDummyViewController() -> UIViewController {
        let vc = UIViewController()
        return vc
    }
    
        
    private func makeFoundDetailViewController(foundIdentifier: String, sender viewController: UIViewController) -> FounDetailViewController {
        let foundDetailViewController = FounDetailViewController(firebaseFoundService: firebaseFoundService, foundIdentifier: foundIdentifier)
        return foundDetailViewController
    }
    
    private func makeCommentCollectionViewController(lost: Lost) -> CommentViewController {
        let commentCollectionViewController = CommentViewController(firebaseLostCommentService: firebaseLostCommentService, firebaseCloudMessaging: firebaseCloudMessaing, lost: lost)
        return commentCollectionViewController
    }
    
    private func makeMyInfoViewController() -> MyInfoViewController {
        let myInfoViewController = MyInfoViewController(firebaseLostService: firebaseLostService, firebaseFoundService: firebaseFoundService, firebaseAuthService: firebaseAuthService, firebaseUserService: firebaseUserService)
        
        
        myInfoViewController.logOut = { [unowned self] in
            window?.rootViewController = makeLoginVC()
        }
        
        myInfoViewController.lostCellTapped = { [unowned self] lost in
            let detailViewController = makeDetailVC(lostIdentifier: lost.lostIdentifier, sender: myInfoViewController)
            
            //            detailViewController.hidesBottomBarWhenPushed = true
            
            fourthTabNavigationController.pushViewController(detailViewController, animated: true)
        }
        
        myInfoViewController.settingButton = { [unowned self] in
            let settingModalViewController = SettingModalViewController(firebaseAuthService: firebaseAuthService)
            
            settingModalViewController.logOut = {
                self.window?.rootViewController = self.makeLoginVC()
            }
            
            myInfoViewController.present(settingModalViewController, animated: true)
        }
        
        myInfoViewController.foundCellTapped = { [unowned self] found in
            let foundDetailViewController = makeFoundDetailViewController(foundIdentifier: found.foundIdentifier, sender: myInfoViewController)
            foundDetailViewController.hidesBottomBarWhenPushed = true
            fourthTabNavigationController.pushViewController(foundDetailViewController, animated: true)
        }
        
        return myInfoViewController
    }
    
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
}

// 로스트테이블 -> 글내용으로 들어가고 -> 수정을 누른다 -> 디테일은 변화해있다 -> 테이블뷰는 그대로있다 -> 테이블뷰를 누르면은 수정되기 전 그 로스트를 이용해서 다시 디테일을 그린다 -> 수정하기전 디테일이다
///                                                                                                                              ->  테이블뷰를 바꿔주던가
///                                                                                                                              -> identifier API를 새로해가지고 만들어준다 디테일 들어갈때마다 API를 한다
///
