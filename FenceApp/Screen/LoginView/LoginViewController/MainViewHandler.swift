
import UIKit
import RxSwift
import FirebaseFirestore

class MainViewHandler {
    
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

    func setNavigationControllers() {
          firstTabNavigationController.viewControllers = [makeMapViewVC()]
          secondTabNavigationController.viewControllers = [makeLostViewVC()]
          thirdTabNavigationController.viewControllers = [makeChatViewController()]
          fourthTabNavigationController.viewControllers = [makeMyInfoViewController()]
      }
    
    func makeTabbarController() -> CustomTabBarController {
        let TabbarController = CustomTabBarController(controllers: [firstTabNavigationController, secondTabNavigationController, makeDummyViewController(), thirdTabNavigationController, fourthTabNavigationController], locationManager: locationManager, firebaseFoundSerivce: firebaseFoundService)
        
        return TabbarController
    }
    
    private func makeMapViewVC() -> MapViewController {
        
        let vc = MapViewController(firebaseLostService: firebaseLostService, firebaseFoundService: firebaseFoundService, locationManager: locationManager)
        
        vc.filterTapped = {
            
            let modelViewController = CustomModalViewController()
//            modelViewController.delegate = vc
            vc.present(modelViewController, animated: true)
            
        }
        return vc
    }
    
    private func makeLostViewVC() -> LostListViewController {
        let vc = LostListViewController(fireBaseLostService: firebaseLostService, firebaseLostCommentService: firebaseLostCommentService, firebaseAuthService: firebaseAuthService, firebaseUserService: firebaseUserService)
        
        vc.filterTapped = {
            let filterModalViewController = CustomFilterModalViewController()
            filterModalViewController.delegate = vc
            vc.present(filterModalViewController, animated: true)
        }
        
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




//
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
