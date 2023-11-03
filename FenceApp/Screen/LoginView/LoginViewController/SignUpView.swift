import UIKit
import RiveRuntime
import RxSwift

final class SignUpView: UIView {
    
    private var userService: FirebaseUserService
    private var authService: FirebaseAuthService
    
    var profileImageURL = PublishSubject<URL>()
    private var pickedImageURL: URL?
    
    private(set) var didRequestImagePicker = PublishSubject<Void>()
    private var didFinishPickingImage = PublishSubject<UIImage>()
    private var didCancelImagePicker = PublishSubject<Void>()
    private lazy var authenticationView = AuthenticationView()
    let signUpAuthSuccessful = PublishSubject<Void>()
    let cancelSignupViewSubject = PublishSubject<Void>()
    
    private let disposeBag = DisposeBag()

    private var profileAnimationViewModel = RiveViewModel(fileName: "profile")
    private(set) lazy var profileRiveAnimationView: RiveView = RiveView().withViewModel(profileAnimationViewModel)
    private(set) lazy var profileImageButton: UIButton = UIButton()
        .withTarget(self, action: #selector(profileImageButtonTapped))
        .withCornerRadius(50)
        .withBottomBorder(width: 3)
        .withBorder(color: UIColor(hexCode: "04364A"), width: 3.0)


    private lazy var emailTextField = UITextField()
        .withPlaceholder("Email")
        .withInsets(left: 5, right: 20)
        .withBottomBorder(width: 3)


    private lazy var nicknameTextField = UITextField()
        .withPlaceholder("Nick Name")
        .withInsets(left: 5, right: 20)
        .withBottomBorder(width: 3)

    private lazy var passwordTextField = UITextField()
        .withPlaceholder("Password")
        .withInsets(left: 5, right: 20)
        .withBottomBorder(width: 3)


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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        emailTextField
            .updateBottomBorder(color: UIColor(hexCode: "04364A"), width: 3)
            .setupForValidation(type: .email)

        nicknameTextField
            .updateBottomBorder(color: UIColor(hexCode: "04364A"), width: 3)
            .setupForValidation(type: .nickName)

        
        passwordTextField
            .updateBottomBorder(color: UIColor(hexCode: "04364A"), width: 3)
            .setupForValidation(type: .password)
    }
    
    init(authService: FirebaseAuthService, userService: FirebaseUserService) {
        self.authService = authService
        self.userService = userService
        super.init(frame: .zero)
        configureUI()
        fetchImageURL()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
    
}




// MARK: - Congfigure UI
private extension SignUpView {
    
    func configureUI() {
        self.backgroundColor = UIColor(hexCode: "CBEDC4")

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
        signupWithFirebase()
        
        
    }
    
    @objc func cancelButtonTapped() {
        cancelSignupViewSubject.onNext(())
    }
}


//MARK: - SignUp
extension SignUpView {
    
    func signupWithFirebase() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let nickname = nicknameTextField.text,
              let imageUrlString = pickedImageURL?.absoluteString else { return }
        Task {
            do {
                let authResult = try await authService.signUpUser(email: email, password: password)
                let userResponseDTO = UserResponseDTO(email: email, profileImageURL: imageUrlString, identifier: authResult.user.uid, nickname: nickname)
                try await userService.createUser(userResponseDTO: userResponseDTO)
                print("Successfully \(#function)")
                self.signUpAuthSuccessful.onNext(())
            } catch {
                print("Error occurred: \(error)")
            }
        }
    }
}


//MARK: - Fetch Image URL From LoginVC
extension SignUpView {
    func fetchImageURL() {
        profileImageURL
            .subscribe(onNext: { [weak self] url in
                self?.pickedImageURL = url
            })
            .disposed(by: disposeBag)
    }
}


