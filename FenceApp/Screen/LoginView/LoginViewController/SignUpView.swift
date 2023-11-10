import UIKit
import RiveRuntime
import RxSwift
import FirebaseAuth

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
    
    
    private lazy var emailTextField = UITextField()
        .withPlaceholder("Email@gmail.com")
        .withInsets(left: 5, right: 20)
        .setCharacterLimit(30)
        .withCapitalization(.none)
        .withKeyboardType(.emailAddress)
        .withNoAutocorrection()
    
    
    private lazy var nicknameTextField = UITextField()
        .withPlaceholder("닉네임: 3글자 이상")
        .withInsets(left: 5, right: 20)
        .setCharacterLimit(20)
        .withKeyboardType(.alphabet)
        .withCapitalization(.none)
        .withNoAutocorrection()
    
    
    private lazy var passwordTextField = UITextField()
        .withPlaceholder("비밀번호: 6글자 이상")
        .withInsets(left: 5, right: 20)
        .withSecured()
        .setCharacterLimit(20)
        .withKeyboardType(.emailAddress)
        .withNoAutocorrection()
    
    private lazy var signupButton = UIButton()
        .withTitle("가입 완료!")
        .withCornerRadius(20)
        .withTarget(self, action: #selector(signupButtonTapped))
    
    private lazy var cancelButton = UIButton()
        .withTitle("뒤로가기")
        .withTextColor(ColorHandler.shared.textColor)
        .withCornerRadius(20)
        .withTarget(self, action: #selector(cancelButtonTapped))
    
    
    // MARK: - Initialization
    
    override func layoutSubviews() {
        super.layoutSubviews()
        emailTextField
            .setupForValidation(type: .email)
        nicknameTextField
            .setupForValidation(type: .nickName)
        passwordTextField
            .setupForValidation(type: .password)
        validateSignupButton()
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

extension SignUpView {
    func validateSignupButton() {
        Observable
            .combineLatest(
                emailTextField.validationHandler!.isValidRelay,
                nicknameTextField.validationHandler!.isValidRelay,
                passwordTextField.validationHandler!.isValidRelay
            ) {isEmailValid, isNicknameValid, isPasswordValid in
                return isEmailValid && isNicknameValid && isPasswordValid
            }
            .subscribe(onNext: { [weak self] allValid in
                DispatchQueue.main.async {
                    let backgroundColor = allValid ? ColorHandler.shared.buttonActivatedColor : ColorHandler.shared.buttonDeactivateColor
                    self?.signupButton.backgroundColor = backgroundColor
                    self?.signupButton.isEnabled = allValid
                }
            })
    }
}


// MARK: - Congfigure UI
private extension SignUpView {
    
    func configureUI() {
        self.backgroundColor = .white
        
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



//MARK: - Action
private extension SignUpView {
    
    @objc func profileImageButtonTapped() {
        didRequestImagePicker.onNext(())
    }
    
    
    @objc func signupButtonTapped() {
        LoadingViewHandler.showLoading()
        print("signupButtonTapped called")
        signupWithFirebase()
    }
    
    @objc func cancelButtonTapped() {
        cancelSignupViewSubject.onNext(())
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




// MARK: - SignUp
extension SignUpView {
    
    func signupWithFirebase() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let nickname = nicknameTextField.text else {
            DispatchQueue.main.async {
                LoadingViewHandler.hideLoading()
                AlertHandler.shared.presentErrorAlert(for: .formatError("모든 필드를 채워주세요"))
            }
            return
        }
        
        let imageUrlString = pickedImageURL?.absoluteString ?? "https://upload.wikimedia.org/wikipedia/commons/thumb/4/43/Cute_dog.jpg/1024px-Cute_dog.jpg"
        
        Task {
            do {
                let authResult = try await self.authService.signUpUser(email: email, password: password)
                let userResponseDTO = UserResponseDTO(email: email, profileImageURL: imageUrlString, identifier: authResult.user.uid, nickname: nickname, userFCMToken: CurrentUserInfo.shared.userToken ?? "")
                try await userService.createUser(userResponseDTO: userResponseDTO)
                
                let fbUser = FBUser(email: email, profileImageURL: imageUrlString, identifier: authResult.user.uid, nickname: nickname)
                CurrentUserInfo.shared.currentUser = fbUser
                DispatchQueue.main.async {
                    LoadingViewHandler.hideLoading()
                    self.signUpAuthSuccessful.onNext(())
                }
            } catch let error as NSError {
                DispatchQueue.main.async {
                    LoadingViewHandler.hideLoading()
                    self.handleSignUpError(error)
                }
            }
        }
    }
    
    // MARK: - SignUp
    
    private func handleSignUpError(_ error: Error) {
        let nsError = error as NSError
        
        var errorMessage = "회원가입 중 에러가 발생했습니다"
        switch nsError.code {
        case AuthErrorCode.networkError.rawValue:
            errorMessage = "네트워크 연결을 확인해주세요."
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            errorMessage = "이미 사용중인 이메일입니다."
        case AuthErrorCode.userDisabled.rawValue:
            errorMessage = "사용자 계정이 비활성화되었습니다."
        default:
            errorMessage = nsError.localizedDescription
        }
        
        DispatchQueue.main.async {
            AlertHandler.shared.presentErrorAlert(for: .authenticationError(errorMessage))
        }
    }
}



