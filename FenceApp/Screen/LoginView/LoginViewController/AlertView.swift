




import UIKit

// MARK: - Success Types
enum SuccessMessage {
    case registrationComplete(String)
    case operationSuccessful(String)
    case sendMessageSuccessful(String)
}

// MARK: - Error Types
enum AppError: Error {
    case networkError(String)
    case authenticationError(String)
    case formatError(String)
    case loadImageError(String)
    case permissionError(String)
    case unknownError
}

// MARK: - Alert Handler Singleton
class AlertHandler {
    
    static let shared = AlertHandler()
    
    private init() {}
    
    private func generateSuccessAlert(for successMessage: SuccessMessage) -> (UIViewController) -> Void {
        let (title, message) = detailedSuccessMessage(for: successMessage)
        
        return { viewController in
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    func presentSuccessAlert(for successMessage: SuccessMessage) {
        if let topViewController = currentViewController() {
            let alert = generateSuccessAlert(for: successMessage)
            alert(topViewController)
        }
    }
    
    func presentErrorAlert(for error: AppError) {
        if let topViewController = currentViewController() {
            let alert = generateErrorAlert(for: error)
            alert(topViewController)
        }
    }
    
    
    /*
     UIApplication
     |
     |-- UIWindow (keyWindow)
     |
     |-- RootViewController (UIViewController)
     |
     |-- PresentedViewController (UIViewController)
     |
     |-- PresentedViewController (UIViewController)
     ...
     */
    
    private func currentViewController(head: UIViewController? = UIApplication.shared.windows.first(where: { $0.isKeyWindow })?.rootViewController) -> UIViewController? {
        var currentViewController = head
        while let nextViewController = currentViewController?.presentedViewController {
            currentViewController = nextViewController
            
        }
        return currentViewController
    }
    
    
    private func detailedSuccessMessage(for success: SuccessMessage) -> (title: String, message: String) {
        switch success {
        case .registrationComplete(let customMessage):
            return ("🥳등록 성공🥳", customMessage)
        case .operationSuccessful(let customMessage):
            return ("🥳작업 성공🥳", customMessage)
        case .sendMessageSuccessful(let customMessage):
            return("🥳이메일 전송 성공🥳", customMessage)
        }
    }
    
    private func generateErrorAlert(for error: AppError) -> (UIViewController) -> Void {
        let (title, message) = detailedMessage(for: error)
        return { viewController in
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
    
    private func detailedMessage(for error: AppError) -> (title: String, message: String) {
        switch error {
        case .networkError(let customMessage):
            return ("🥹통신 에러🥹", customMessage)
        case .authenticationError(let customMessage):
            return ("🥹인증 에러🥹", customMessage)
        case .formatError(let customMessage):
            return ("🥹입력 에러🥹", customMessage)
        case .loadImageError(let customMessage):
            return ("🥹이미지 불러오기 에러🥹", customMessage)
        case .permissionError(let customMessage):
            return ("🥹권한 허용 에러🥹", customMessage)
        case .unknownError:
            return ("🥹에러🥹", "무언가 잘못되었습니다")
        }
    }
    
    private func generateSuccessAlertController(for successMessage: SuccessMessage) -> UIAlertController {
        let (title, message) = detailedSuccessMessage(for: successMessage)
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        return alertController
    }
    
    func presentSuccessAlertWithAction(for successMessage: SuccessMessage, action: @escaping (UIAlertAction) -> Void) {
        if let topViewController = currentViewController() {
            let alertController = generateSuccessAlertController(for: successMessage)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: action))
            topViewController.present(alertController, animated: true, completion: nil)
        }
    }

    
    private func generateErrorAlertController(for error: AppError) -> UIAlertController {
        let (title, message) = detailedMessage(for: error)
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        return alertController
    }
    
    
    // 여기에 인자로 Error, action
    
    func presentErrorAlertWithAction(for error: AppError, action: @escaping (UIAlertAction) -> Void) {
        if let topViewController = currentViewController() {
            let alertController = generateErrorAlertController(for: error)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: action))
            topViewController.present(alertController, animated: true, completion: nil)
        }
    }
}

