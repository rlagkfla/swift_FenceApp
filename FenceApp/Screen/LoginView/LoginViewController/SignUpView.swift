import UIKit
import RiveRuntime
import RxSwift
import RxKeyboard

final class SignUpView: UIView {
    
    private(set) var didRequestImagePicker = PublishSubject<Void>()
    private var didFinishPickingImage = PublishSubject<UIImage>()
    private var didCancelImagePicker = PublishSubject<Void>()
    private lazy var authenticationView = AuthenticationView()
    private let disposeBag = DisposeBag()

    private var profileAnimationViewModel = RiveViewModel(fileName: "profile")
    private(set) lazy var profileRiveAnimationView: RiveView = RiveView().withViewModel(profileAnimationViewModel)
    private(set) lazy var profileImageButton: UIButton = UIButton()
        .withTarget(self, action: #selector(profileImageButtonTapped))
        .withCornerRadius(50)
        .withBorder(color: UIColor(hexCode: "04364A"), width: 3.0)

    private lazy var emailTextField = UITextField()
        .withPlaceholder("Email")
        .withInsets(left: 20, right: 20)
        .withCornerRadius(20)
        .withBlurEffect()
        .withBorder(color: UIColor(hexCode: "04364A"), width: 3.0)
    
    private lazy var nicknameTextField = UITextField()
        .withPlaceholder("Nick Name")
        .withInsets(left: 20, right: 20)
        .withCornerRadius(20)
        .withBlurEffect()
        .withBorder(color: UIColor(hexCode: "04364A"), width: 3.0)
    
    private lazy var passwordTextField = UITextField()
        .withPlaceholder("Password")
        .withInsets(left: 20, right: 20)
        .withCornerRadius(20)
        .withBlurEffect()
        .withBorder(color: UIColor(hexCode: "04364A"), width: 3.0)
    
    private lazy var signupButton = UIButton()
        .withTitle("가입 완료!")
        .withBorder(color: UIColor(hexCode: "04364A"), width: 3.0)
        .withBlurEffect()
        .withCornerRadius(20)
        .withTextColor(.black)
        .withTarget(self, action: #selector(signupButtonTapped))
    
    private lazy var cancelButton = UIButton()
        .withTitle("뒤로가기")
        .withBorder(color: UIColor(hexCode: "04364A"), width: 3.0)
        .withBlurEffect()
        .withCornerRadius(20)
        .withTextColor(.black)
        .withTarget(self, action: #selector(cancelButtonTapped))
    
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        setupTFValidate()

    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
}


//MARK: - isValid TextField Format
extension SignUpView {
    func setupTFValidate() {
        emailTextField
            .setupForValidation(type: .email)
        
        nicknameTextField
            .setupForValidation(type: .nickName)
        
        passwordTextField
            .setupForValidation(type: .password)
        
        setupSignupButtonValidate()
    }
    
    func setupSignupButtonValidate() {
        Observable.combineLatest(
             emailTextField.validationHandler!.isValidRelay,
             nicknameTextField.validationHandler!.isValidRelay,
             passwordTextField.validationHandler!.isValidRelay

         ) { emailIsValid, nickNameIsValid ,passwordIsValid in
             return emailIsValid && passwordIsValid && passwordIsValid
         }
         .do(onNext: { [weak self] isEnabled in
             DispatchQueue.main.async {
                 if isEnabled {
                     self?.signupButton.layer.borderColor = UIColor(hexCode: "68B984").cgColor
                 } else {
                     self?.signupButton.layer.borderColor = UIColor(hexCode: "04364A").cgColor
                 }
             }
         })
         .bind(to: signupButton.rx.isEnabled)
         .disposed(by: disposeBag)
     }
}


// MARK: - Congfigure UI
private extension SignUpView {
    
    func configureUI() {
        addSubviews(emailTextField,profileImageButton,nicknameTextField,passwordTextField,signupButton,cancelButton)
        profileImageButton.addSubview(profileRiveAnimationView)
        configureConstraints()
    }
    
    
    func configureConstraints() {
        profileImageButton
            .withSize(100,100)
            .positionCenterX()
            .positionMultipleY(multiplier: 0.4)
        
        emailTextField
            .withSize(widthRatioOfSuperview: 0.7)
            .withHeight(40)
            .putBelow(profileImageButton, 50)
            .positionCenterX()
        
        nicknameTextField
            .withSize(widthRatioOfSuperview: 0.7)
            .withHeight(40)
            .putBelow(emailTextField, 20)
            .positionCenterX()
        
        passwordTextField
            .withSize(widthRatioOfSuperview: 0.7)
            .withHeight(40)
            .putBelow(nicknameTextField, 20)
            .positionCenterX()
        
        signupButton
            .withSize(widthRatioOfSuperview: 0.5)
            .withHeight(40)
            .putBelow(passwordTextField, 40)
            .positionCenterX()
        
        cancelButton
            .withSize(widthRatioOfSuperview: 0.5)
            .withHeight(40)
            .putBelow(signupButton, 10)
            .positionCenterX()
        
        profileRiveAnimationView.snp.makeConstraints { $0.edges.equalTo(profileImageButton) }
    }
}


//MARK: - isValid TextField Format
extension SignUpView {
    
    func setupValidate() {
        emailTextField
            .setupForValidation(type: .email)
        
        passwordTextField
            .setupForValidation(type: .password)
        
        nicknameTextField
            .setupForValidation(type: .nickName)
    }
}


//MARK: - Action
private extension SignUpView {
    
    @objc func profileImageButtonTapped() {
        didRequestImagePicker.onNext(())
    }
    
    
    
    @objc func signupButtonTapped() {
        
        
    }
    
    @objc func cancelButtonTapped() {
        self.removeFromSuperview()
    }
}

