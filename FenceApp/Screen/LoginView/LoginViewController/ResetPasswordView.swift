import UIKit
import FirebaseAuth
import RxSwift
import RxKeyboard
import RiveRuntime

class ResetPasswordView: UIView {
    
    let disposeBag = DisposeBag()
    
    let resetEmailSent = PublishSubject<Void>()
    let deinitResetPasswordView = PublishSubject<Void>()

    private var viewModel = RiveViewModel(fileName: "cat")
    private lazy var riveView = RiveView()
        .withViewModel(viewModel)

    
    private lazy var emailTextField = UITextField()
        .withPlaceholder("Email")
        .withCornerRadius(20)
        .withInsets(left: 20, right: 20)
        .withBorder(color: UIColor(hexCode: "6C5F5B"), width: 3.0)
    
    private lazy var resetPasswordButton = UIButton()
        .withTitle("비밀번호 재설정하기")
        .withTextColor(.black)
        .withTarget(self, action: #selector(resetPasswordButtonTapped))
        .withCornerRadius(20)
        .withBorder(color: UIColor(hexCode: "6C5F5B"), width: 3.0)
    
    private lazy var cancelButton = UIButton()
        .withTitle("뒤로가기")
        .withTextColor(.black)
        .withTarget(self, action: #selector(cancelButtonTapped))
        .withCornerRadius(20)
        .withBorder(color: UIColor(hexCode: "6C5F5B"), width: 3.0)
    
    deinit {
        print("ResetPasswor Deinit")
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupValidate()
        handleKeyboardAdjustment(adjustmentFactor: 0.1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - UI Setup

extension ResetPasswordView {
    func setupUI() {
        addSubviews(emailTextField, resetPasswordButton,cancelButton,riveView)
        configureConstraints()
    }
    
    func configureConstraints() {
        
        emailTextField
            .positionCenterX()
            .positionCenterY()
            .withSize(widthRatioOfSuperview: 0.8)
            .withHeight(40)

        riveView
            .putAbove(emailTextField, 8)
            .positionCenterX()
            .withSize(200, 150)

        resetPasswordButton
            .putBelow(emailTextField, 20)
            .positionCenterX()
            .withSize(widthRatioOfSuperview: 0.6)
            .withHeight(40)
        
        cancelButton
            .putBelow(resetPasswordButton, 20)
            .positionCenterX()
            .withSize(widthRatioOfSuperview: 0.6)
            .withHeight(40)

    }
}

// MARK: - Actions

extension ResetPasswordView {
    
    @objc func resetPasswordButtonTapped() {
        guard let email = emailTextField.text, !email.isEmpty else {
            showInvalidEmailAlert()
            return
        }

        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] (error) in
            if let error = error {
                self?.showErrorAlert(message: error.localizedDescription)
                return
            }
            
            self?.resetEmailSent.onNext(())
        }
    }
    
    func showInvalidEmailAlert() {
        showAlert(title: "Invalid Input", message: "Please enter a valid email address.")
    }
    
    func showErrorAlert(message: String) {
        showAlert(title: "Error", message: message)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
    }
    
    
    @objc func cancelButtonTapped() {
        deinitResetPasswordView.onNext(())
    }
}


//MARK: - isValid TextField Format
extension ResetPasswordView {
    func setupValidate() {
        emailTextField.setupForValidation(type: .email)
    }
}


//MARK: - Handling keyboard
extension ResetPasswordView {
        
    func adjustForKeyboard() {
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { [weak self] keyboardHeight in
                if keyboardHeight > 0 {
                    self?.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight / 2)
                } else {
                    self?.transform = .identity
                }
            })
            .disposed(by: disposeBag)
    }
}
