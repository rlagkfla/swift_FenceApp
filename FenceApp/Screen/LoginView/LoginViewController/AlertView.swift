import UIKit

// MARK: - Error Types
enum AppError: Error {
    case networkError(String)
    case authenticationError(String)
    case formatError(String)
    case unknownError
}



// MARK: - Alert Handler
struct AlertHandler {

    typealias AlertAction = (title: String, style: UIAlertAction.Style, handler: ((UIAlertAction) -> Void)?)

    func generateAlert(for error: AppError) -> (UIViewController) -> Void {
        let (title, message) = detailedMessage(for: error)
        return prepareAlert(title: title, message: message)
    }

    private func detailedMessage(for error: AppError) -> (title: String, message: String) {
        switch error {
        case .networkError(let customMessage):
            return ("🥹통신 에러🥹", customMessage)
        case .authenticationError(let customMessage):
            return ("🥹인증 에러🥹", customMessage)
        case .formatError(let customMessage):
            return ("🥹입력 형식 에러🥹", customMessage)
        case .unknownError:
            return ("🥹Unknown Error🥹", "무언가 잘못되었습니다")
        }
    }

    private func prepareAlert(title: String?, message: String?, actions: [AlertAction] = []) -> (UIViewController) -> Void {
        
        return { viewController in
            
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            if actions.isEmpty {
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            } else {
                for action in actions {
                    alertController.addAction(UIAlertAction(title: action.title, style: action.style, handler: action.handler))
                }
            }
            
            viewController.present(alertController, animated: true, completion: nil)
        }
    }
}
