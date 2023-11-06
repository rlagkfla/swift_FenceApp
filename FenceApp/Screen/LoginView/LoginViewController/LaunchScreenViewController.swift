
import UIKit

class LaunchScreenViewController: UIViewController {
    
    private let imageView = UIImageView()
        .withImage("LaunchImage")

    
    deinit { print("LauncScreen Deinitialize!!") }
}



//MARK: - ViewCycle

extension LaunchScreenViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.addSubview(imageView)
        setupUI()
    }
}


//MARK: - Setup UI

extension LaunchScreenViewController {
    
    func setupUI() {
        view.backgroundColor = .white
        imageView.contentMode = .scaleAspectFit
        setupConstraints()
        view.addSubview(imageView)
    }
    
    func setupConstraints() {
        imageView
            .positionCenterX()
            .positionCenterY()
            .putFullScreen()
    }
}


