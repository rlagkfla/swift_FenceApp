
//MARK: - Module
import UIKit
import SnapKit
import RiveRuntime

//MARK: - Properties & Deinit
class LoginViewController: UIViewController {
    
    //1. Background animation
    private var viewModel = RiveViewModel(fileName: "background")
    private lazy var riveView = RiveView()
        .withBlurEffect()
        .withViewModel(viewModel)
    
    
    
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

//MARK: - Configure UI
extension LoginViewController {
    
    func configure() {
        view.backgroundColor = .white
        view.withBackgroundImage(named: "Spline", at: CGPoint(x: 1.0, y: 0.8), size: CGSize(width: 700, height: 1000))
        view.addSubviews(riveView)
        configureConstraints()
    }
    
    func configureConstraints() {
        riveView.snp.makeConstraints {
            $0.edges.equalToSuperview()
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
    
    func withBackgroundImage(named imageName: String, at position: CGPoint, size: CGSize? = nil) -> Self {
        let imageView = UIImageView(image: UIImage(named: imageName))
        imageView.contentMode = .scaleAspectFit
        insertSubview(imageView, at: 0)
        
        imageView.snp.makeConstraints { make in
            make.centerX.equalTo(snp.leading).offset(bounds.size.width * position.x)
            make.centerY.equalTo(snp.top).offset(bounds.size.height * position.y)
            
            if let size = size {
                make.width.equalTo(size.width)
                make.height.equalTo(size.height)
            }
        }
        
        return self
    }
    
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach { addSubview($0) }
    }
    
}
