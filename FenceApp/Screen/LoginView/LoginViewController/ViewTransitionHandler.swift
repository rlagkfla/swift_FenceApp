import UIKit

class ViewTransitionHandler {
    
    private var window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    func transitionToMainView() {
        let mainViewHandler = MainViewHandler()
        window?.rootViewController = mainViewHandler.makeTabbarController()
        window?.makeKeyAndVisible()
        mainViewHandler.setNavigationControllers()
    }
}
