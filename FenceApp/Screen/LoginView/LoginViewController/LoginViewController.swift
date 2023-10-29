//MARK: - Module

//Framework
import UIKit
import Security
import PhotosUI

//Library
import RiveRuntime
import RxCocoa
import RxKeyboard
import RxSwift
import SnapKit
import FirebaseAuth
import FirebaseFirestore


//MARK: - Properties & Deinit
final class LoginViewController: UIViewController {
    
    
    //------------------------------------------------------------------------
    
    
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
    
    //------------------------------------------------------------------------
    
    
    private let alertHandler = AlertHandler()

    let authView = AuthenticationView()
    let signUpView = SignUpView()
    let resetPasswordView = ResetPasswordView()
    
    
    private var disposeBag = DisposeBag()
    private var emailTextSubject = BehaviorSubject<String?>(value: nil)
    
    private lazy var titleLabel = UILabel()
        .withText("찾아줄개")
        .withFont(40)
        .withFontWeight(.bold)
        .withTextColor(UIColor(hexCode: "524A4E"))
    
    private var viewModel = RiveViewModel(fileName: "background")
    private lazy var riveView = RiveView()
        .withViewModel(viewModel)
        .withBlurEffect()
    
    private lazy var emailTextField = UITextField()
        .withPlaceholder("Email")
        .withCornerRadius(20)
        .withInsets(left: 20, right: 20)
        .withBorder(color: UIColor(hexCode: "6C5F5B"), width: 3.0)
    
    private let passwordTextField = UITextField()
        .withPlaceholder("Password")
        .withSecured()
        .withCornerRadius(20)
        .withInsets(left: 20, right: 20)
        .withBorder(color: UIColor(hexCode: "6C5F5B"), width: 3.0)
    
    private lazy var loginButton = UIButton()
        .withTitle("Login")
        .withTextColor(.black)
        .withTarget(self, action: #selector(loginButtonTapped))
        .withCornerRadius(20)
        .withBorder(color: UIColor(hexCode: "6C5F5B"), width: 3.0)
    
    private lazy var signUpButton = UIButton()
        .withTitle("Sign Up")
        .withTextColor(.black)
        .withTarget(self, action: #selector(signUpButtonTapped))
    
    private lazy var findPasswordButton = UIButton()
        .withTitle("Find Password")
        .withTextColor(.black)
        .withTarget(self, action: #selector(findPasswordButtonTapped))
    
    private lazy var buttonStack = UIStackView()
        .withAxis(.horizontal)
        .withDistribution(.fillEqually)
        .withSpacing(10)
        .withMargins(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
    
    deinit {
        print("Successfully LoginVC has been deinitialized!")
    }
}


//MARK: - ViewCycle
extension LoginViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTFValidate()
        view.handleKeyboardAdjustment(adjustmentFactor: 0.25)
        setupUI()
        setUpKeychain()
        KeychainManager.printAllKeychainItems()
        bindImagePicker()
    }
}


//MARK: - SetupUI
private extension LoginViewController {
    
    func setupUI() {
        
        view
            .withBackgroundColor(.white)
            .withBackgroundImage(
                named: "Spline",
                at: CGPoint(x: 1.0, y: 1.0),
                size: CGSize(width: 700, height: 1000)
            )
            .addSubviews(riveView,emailTextField,titleLabel,passwordTextField,loginButton,signUpButton,findPasswordButton,buttonStack)
        
        buttonStack
            .withArrangedSubviews(signUpButton,findPasswordButton)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        
        riveView
            .putFullScreen()
        
        emailTextField
            .positionCenterX()
            .positionMultipleY(multiplier: 0.95)
            .withSize(250, 40)
        
        titleLabel
            .positionCenterX()
            .putAbove(emailTextField, 50)
        
        passwordTextField
            .putBelow(emailTextField, 20)
            .positionCenterX()
            .withSize(250, 40)
        
        loginButton
            .putBelow(passwordTextField, 20)
            .positionCenterX()
            .withSize(150, 40)
        
        buttonStack
            .putBelow(loginButton, 30)
            .positionMultipleX(multiplier: 0.5)
    }
}



//MARK: - Button Action
private extension LoginViewController {

    @objc func loginButtonTapped() {
        
        handleAlertWithError()
        guard let email = emailTextField.text,
              let password = passwordTextField.text else {return}

        Task {
            do {
                try await firebaseAuthService.signInUser(email: email, password: password)
                print("Successfully \(#function)")
                handleKeychain()
                assignRootView()
            } catch {
                print("Error logging in: \(error)")
            }
        }
    }

    @objc func signUpButtonTapped() {
        handleAuthenticationView()
    }
    
    @objc func findPasswordButtonTapped() {
        handleResetPasswordView()
    }
}

//MARK: - Present/Deinit AuthView
private extension LoginViewController {
    
    func handleAuthenticationView() {
        view.addSubviews(authView)
        setupAuthView()
        cancelAuthView()
        succesPhoneAuth()
    }
    
    func setupAuthView() {
        authView
            .positionCenterY()
            .positionCenterX()
            .withSize(widthRatioOfSuperview: 0.8)
            .withSize(heightOfSuperview: 0.5)
            .withCornerRadius(20)
            .withBlurEffect()
    }
    
    func cancelAuthView() {
        authView.deinitAuthView
            .subscribe(onNext: { [weak self, weak authView] in
                authView?.removeFromSuperview()
            })
            .disposed(by: disposeBag)
    }
    
    
    func succesPhoneAuth() {
        
        // 인증성공 후
        authView.authenticationSuccessful
            .subscribe(onNext: { [weak self, weak authView] in

                    authView?.removeFromSuperview()
                DispatchQueue.main.async {
                    self?.presentSignUpView()
                    self?.presentSignUpView()

                }
            })
            .disposed(by: disposeBag)
    }
}

//MARK: - Handle Alert with Error case

extension LoginViewController {
    
    func handleAlertWithError() {
        handleTextFormatError()
    }
    
    
    func showAlert(for error: AppError) {
        let alertPresenter = alertHandler.generateAlert(for: error)
        alertPresenter(self)
    }

    //MARK: TextFormat Error
    func handleTextFormatError() {
        if !emailTextField.validationHandler!.isValidEmail(emailTextField.text) {
            showAlert(for: .formatError("잘못됫 이메일 형식입니다"))
        } else if !passwordTextField.validationHandler!.isValidPassWord(passwordTextField.text) {
            showAlert(for: .formatError("패스워드는 6글자 이상입니다"))
        }
    }
}


//MARK: - handle SignUpView
extension LoginViewController {
    
    func handlesSignupView() {
        presentSignUpView()
        setUpSignUpView()
    }
    
    
    func presentSignUpView() {
        setUpSignUpView()
        view.addSubview(signUpView)
    }
    
    func setUpSignUpView() {
        signUpView
            .positionCenterX()
            .positionCenterY()
            .withSize(widthRatioOfSuperview: 0.8)
            .withSize(heightOfSuperview: 0.7)
            .withCornerRadius(20)
            .withBlurEffect()
    }


}

//MARK: - handleResetPasswordView
extension LoginViewController {
    
    func handleResetPasswordView() {
        setUpResetPasswordView()
        view.addSubview(resetPasswordView)
        deinitResetPasswordView()
    }
    
    func setUpResetPasswordView() {
        resetPasswordView
            .positionCenterY()
            .positionCenterX()
            .withSize(widthRatioOfSuperview: 0.8)
            .withSize(heightOfSuperview: 0.4)
            .withCornerRadius(20)
            .withBlurEffect()
        
        
        resetPasswordView.resetEmailSent
            .subscribe(onNext: { [weak self] in
                self?.showResetEmailSentAlert()
                self?.resetPasswordView.removeFromSuperview()
            })
            .disposed(by: disposeBag)
    }
        
    func showResetEmailSentAlert() {
        let alertController = UIAlertController(title: "Success", message: "A password reset email has been sent!", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }

    func deinitResetPasswordView() {
        resetPasswordView.deinitResetPasswordView
            .subscribe(onNext: { [weak self, weak resetPasswordView] in
                resetPasswordView?.removeFromSuperview()
                
            })
            .disposed(by: disposeBag)
    }
}
    
    
//MARK: - Assign tabBarController as rootView
private extension LoginViewController {
    func assignRootView() {
        setNavigationControllers()
        
        guard let window = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first else { return }
        
        let customTabBarController = CustomTabBarController(controllers: [self.firstTabNavigationController, self.secondTabNavigationController, UIViewController(), self.thirdTabNavigationController, self.fourthTabNavigationController], locationManager: self.locationManager, firebaseFoundSerivce: self.firebaseFoundService)
        
        UIView.transition(with: window, duration: 0.3, options: .transitionCrossDissolve, animations: {
            window.rootViewController = customTabBarController
        }, completion: nil)
    }
}




//MARK: - Setup Keychain
extension LoginViewController {
    
    func handleKeychain() {
        
        let email = emailTextField.text ?? ""
        let success = KeychainManager.deleteAllItems()
        
        if success {
            print("All items deleted successfully")
        } else {
            print("Failed to delete item")
        }
        
        if KeychainManager.saveEmail(email: email) {
            print("Successfully saved email")
        } else {
            print("Failed to save email")
        }
        
    }
    
    
    func setUpKeychain() {
        if let email = KeychainManager.retrieveEmail() {
            emailTextField.text = email
            emailTextSubject.onNext(email)
            emailTextField.validationHandler?.textSubject.onNext(email)
        }
    }
    
}

//MARK: - isValid TextField Format
extension LoginViewController {
    func setupTFValidate() {
        emailTextField
            .setupForValidation(type: .email)
        
        passwordTextField
            .setupForValidation(type: .password)
        
        setupLoginButtonValidate()
    }
    
    func setupLoginButtonValidate() {
        Observable.combineLatest(
            emailTextField.validationHandler!.isValidRelay,
            passwordTextField.validationHandler!.isValidRelay
        ) { emailIsValid, passwordIsValid in
            return emailIsValid && passwordIsValid
        }
        .subscribe(onNext: { [weak self] isEnabled in
            DispatchQueue.main.async {
                if isEnabled {
                    self?.loginButton.layer.borderColor = UIColor(hexCode: "68B984").cgColor
                } else {
                    self?.loginButton.layer.borderColor = UIColor(hexCode: "04364A").cgColor
                }
            }
        })
        .disposed(by: disposeBag)
    }
}

//MARK: - PHPickerVC
extension LoginViewController: PHPickerViewControllerDelegate {
    
    func bindImagePicker() {
        signUpView.didRequestImagePicker
            .subscribe(onNext: { [weak self] in
                self?.presentPHImagePicker()
            })
            .disposed(by: disposeBag)
    }
    
    func presentPHImagePicker() {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        guard let result = results.first,
              result.itemProvider.canLoadObject(ofClass: UIImage.self) else {
            picker.dismiss(animated: true)
            return
        }
        
        result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error loading image: \(error)")
                }
                if let image = image as? UIImage {
                    self?.signUpView.profileRiveAnimationView.removeFromSuperview()
                    self?.signUpView.profileImageButton.setImage(image, for: .normal)
                }
                picker.dismiss(animated: true)
            }
        }
    }
}




//MARK: Setting
extension LoginViewController {
    
    
    
    private func setNavigationControllers() {

        firstTabNavigationController.viewControllers = [makeMapViewVC()]
        secondTabNavigationController.viewControllers = [makeLostViewVC()]
        thirdTabNavigationController.viewControllers = [makeChatViewController()]
        fourthTabNavigationController.viewControllers = [makeMyInfoViewController()]
    }
    
    private func makeTabbarController() -> CustomTabBarController {
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
