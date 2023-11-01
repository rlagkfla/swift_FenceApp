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




//MARK: - Properties & Deinit
final class LoginViewController: UIViewController {
    
    let firebaseAuthService: FirebaseAuthService
    let firebaseUserService: FirebaseUserService
    
    let authPassed: () -> Void

    private let alertHandler = AlertHandler()
    private let authView = AuthenticationView()
    private var signUpView: SignUpView?

    private let resetPasswordView = ResetPasswordView()
    
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
    
    init(firebaseAuthService: FirebaseAuthService, firebaseUserService: FirebaseUserService, authPassed: @escaping () -> Void) {
        self.firebaseAuthService = firebaseAuthService
        self.firebaseUserService = firebaseUserService
        self.authPassed = authPassed
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("Successfully LoginVC has been deinitialized!")
    }
}

//MARK: - ViewCycle
extension LoginViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpView = SignUpView(authService: firebaseAuthService, userService:  firebaseUserService)
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
        handleTextFormatError()
        handleKeychain()
        
        guard let email = emailTextField.text, let password = passwordTextField.text else {return}
        
        Task {
            do {
                try await firebaseAuthService.signInUser(email: email, password: password)
                print("Successfully \(#function)")
                enterMainView()
            } catch {
                print("Login error: \(error)")
                //alert창 넣기
            }
        }
    }
    
    func enterMainView() {
        
//        let window = UIApplication.shared.windows.first { $0.isKeyWindow }
//        let viewTransitionHandler = ViewTransitionHandler(window: window)
//        viewTransitionHandler.transitionToMainView()
        authPassed()
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
        view.addSubview(signUpView!)
        bindSignUpAuthSuccess()

    }
    
    func setUpSignUpView() {
        signUpView!
            .positionCenterX()
            .positionCenterY()
            .withSize(widthRatioOfSuperview: 0.8)
            .withSize(heightOfSuperview: 0.7)
            .withCornerRadius(20)
            .withBlurEffect()
    }
    
    func bindSignUpAuthSuccess() {
        signUpView?.signUpAuthSuccessful
            .subscribe(onNext: { [weak self] in
                self?.signUpView?.removeFromSuperview()
            })
            .disposed(by: disposeBag)
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
            .subscribe(onNext: { [weak self, weak resetPasswordView] in
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
                self?.resetPasswordView.removeFromSuperview()
            })
            .disposed(by: disposeBag)
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
        signUpView?.didRequestImagePicker
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
                    self?.signUpView?.profileRiveAnimationView.removeFromSuperview()
                    self?.signUpView?.profileImageButton.setImage(image, for: .normal)
                    
                    if let imageURL = self?.saveImageToTempDirectory(image) {
                        self?.signUpView?.profileImageURL.onNext(imageURL)
                    }
                }
                picker.dismiss(animated: true)
            }
        }
    }
    
    
    func saveImageToTempDirectory(_ image: UIImage) -> URL? {
        let tempDirectoryURL = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        let imageName = UUID().uuidString
        let fileURL = tempDirectoryURL.appendingPathComponent(imageName).appendingPathExtension("png")
        
        do {
            if let pngData = image.pngData() {
                try pngData.write(to: fileURL, options: .atomicWrite)
                return fileURL
            }
        } catch {
            print("Failed to save image to temp directory:", error)
        }
        return nil
    }

}



