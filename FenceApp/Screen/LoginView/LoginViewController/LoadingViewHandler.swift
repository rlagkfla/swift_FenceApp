
import UIKit


struct LoadingViewHandler {

    private static let loadingViewTag = 999

    private static func currentViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        var head = base
        while let presentedViewController = head?.presentedViewController {
            head = presentedViewController
        }
        return head
    }

    static func showLoading() {
        guard let currentViewController = currentViewController(),
              currentViewController.view.viewWithTag(loadingViewTag) == nil else { return }
        
        let loadingView = UIView(frame: currentViewController.view.bounds)
        loadingView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        loadingView.tag = loadingViewTag

        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = loadingView.center
        activityIndicator.startAnimating()

        loadingView.addSubview(activityIndicator)

        DispatchQueue.main.async {
            currentViewController.view.addSubview(loadingView)
        }
    }

    static func hideLoading() {
        guard let currentViewController = currentViewController(),
              let loadingView = currentViewController.view.viewWithTag(loadingViewTag) else { return }

        DispatchQueue.main.async {
            loadingView.removeFromSuperview()
        }
    }
}
