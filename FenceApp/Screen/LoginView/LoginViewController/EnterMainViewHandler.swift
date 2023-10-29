import UIKit


class EnterMainViewHandler {
    private let window: UIWindow
    
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
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        setNavigationControllers()
        
        let customTabBarController = CustomTabBarController(controllers: [self.firstTabNavigationController, self.secondTabNavigationController, UIViewController(), self.thirdTabNavigationController, self.fourthTabNavigationController], locationManager: self.locationManager, firebaseFoundSerivce: self.firebaseFoundService)
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.window.rootViewController = customTabBarController
        }, completion: nil)
    }
    
    private func setNavigationControllers() {
        firstTabNavigationController.viewControllers = [makeMapViewVC()]
        secondTabNavigationController.viewControllers = [makeLostViewVC()]
        thirdTabNavigationController.viewControllers = [makeChatViewController()]
        fourthTabNavigationController.viewControllers = [makeMyInfoViewController()]
    }
}

extension EnterMainViewHandler {
    private func makeMapViewVC() -> MapViewController {
        let vc = MapViewController(firebaseLostService: firebaseLostService, firebaseFoundService: firebaseFoundService, locationManager: locationManager)
        
        vc.filterTapped = {
            let modelViewController = CustomModalViewController()
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
