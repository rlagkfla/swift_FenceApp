
//MARK: - Module
import UIKit
import SnapKit
import RiveRuntime

//MARK: - Properties & Deinit
class LoginViewController: UIViewController {
    
    //MARK: Background
    private var viewModel = RiveViewModel(fileName: "background")
    private lazy var riveView = RiveView()
        .withBlurEffect()
        .withViewModel(viewModel)
    
    private lazy var backgroundImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "Spline")
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    //MARK: Title label
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "찾아줄개"
        label.textColor = .black
        label.font = .boldSystemFont(ofSize: 50)
        return label
    }()
    
    //MARK: Login button
    private lazy var kakaoLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle("KAKAO LOGIN", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(kakaoLoginButtonTapped), for: .touchUpInside)
        return button
    }().withBlurEffect()
    
    private lazy var appleLoginButton: UIButton = {
        let button = UIButton()
        button.setTitle("APPLE LOGIN", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(appleLoginButtonTapped), for: .touchUpInside)
        return button
    }().withBlurEffect()
    
    //MARK: Deinit
    deinit {
        print("Successfully LoginVC has been deinitialized!")
    }
}

//MARK: - ViewCycle
extension LoginViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

//MARK: - Action
extension LoginViewController {
    
    @objc func kakaoLoginButtonTapped() {
        print("Successfully \(#function)")
    }
    
    @objc func appleLoginButtonTapped() {
        print("Successfully \(#function)")
    }
}

//MARK: - Configure UI
extension LoginViewController {
    
    func configure() {
        view.addSubviews(riveView,backgroundImage,kakaoLoginButton,appleLoginButton,titleLabel)
        view.backgroundColor = .white
        view.sendSubviewToBack(backgroundImage)
        configureConstraints()
    }
    
    func configureConstraints() {
        
        riveView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(kakaoLoginButton.snp.top).offset(-60)
        }
        
        kakaoLoginButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.7)
            $0.height.equalTo(80)

        }
        
        appleLoginButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(kakaoLoginButton.snp.bottom).offset(60)
            $0.width.equalToSuperview().multipliedBy(0.7)
            $0.height.equalTo(80)
        }
        
        backgroundImage.snp.makeConstraints {
            $0.centerX.equalToSuperview().multipliedBy(1.8)
            $0.centerY.equalToSuperview().multipliedBy(1.7)
            $0.width.equalTo(300)
            $0.height.equalTo(500)
        }
    }
}


//MARK: - RiveView extension
extension RiveView {
    func withViewModel(_ viewModel: RiveViewModel) -> RiveView {
        isUserInteractionEnabled = false
        viewModel.setView(self)
        return self
    }
}


//MARK: - UIView extension
extension UIView {
    func withBlurEffect() -> Self {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.isUserInteractionEnabled = false
        if let button = self as? UIButton {
            button.insertSubview(blurEffectView, belowSubview: button.imageView!)
        } else {
            insertSubview(blurEffectView, at: 0)
        }
        return self
    }
    
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach { addSubview($0) }
    }
}
