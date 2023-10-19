import UIKit
import SnapKit
import RiveRuntime
import FirebaseAuth



// MARK: - UIView Extensions
extension UIView {
    
    // MARK: Positioning
    @discardableResult
    func centerX() -> Self {
        guard let superview = self.superview else { return self }
        snp.makeConstraints { $0.centerX.equalTo(superview) }
        return self
    }
    
    @discardableResult
    func centerY() -> Constraint {
        var constraint: Constraint?
        guard let superview = self.superview else { return constraint! }
        snp.makeConstraints {
            constraint = $0.centerY.equalTo(superview).constraint
        }
        return constraint!
    }
    
    @discardableResult
    func below(_ view: UIView, _ offset: CGFloat) -> Self {
        snp.makeConstraints { $0.top.equalTo(view.snp.bottom).offset(offset) }
        return self
    }
    
    @discardableResult
    func above(_ view: UIView, _ offset: CGFloat) -> Self {
        snp.makeConstraints { $0.bottom.equalTo(view.snp.top).offset(-offset) }
        return self
    }
    
    
    func fullScreen() {
        guard let superview = self.superview else { return }
        snp.makeConstraints { $0.edges.equalTo(superview) }
    }
    
    
    // MARK: Sizing
    @discardableResult
    func size(_ width: CGFloat, _ height: CGFloat) -> Self {
        snp.makeConstraints { $0.width.equalTo(width); $0.height.equalTo(height) }
        return self
    }
    
    // MARK: Styling
    @discardableResult
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

    @discardableResult
    func withBorder(color: UIColor, width: CGFloat) -> Self {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
        return self
    }
    
    //MARK: Misc
    func addSubviews(_ subviews: UIView...) {
        subviews.forEach { addSubview($0) }
    }
    
    @discardableResult
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
}

// MARK: - UIButton Extensions
extension UIButton {
    
    @discardableResult
    func withTitle(_ title: String) -> Self {
        setTitle(title, for: .normal)
        return self
    }
    
    @discardableResult
    func withTextColor(_ color: UIColor) -> Self {
        setTitleColor(color, for: .normal)
        return self
    }
    
    @discardableResult
    func withTarget(_ target: Any?, action: Selector) -> Self {
        addTarget(target, action: action, for: .touchUpInside)
        return self
    }
    
    @discardableResult
    func withBackgroundColor(_ color: UIColor) -> Self {
        backgroundColor = color
        return self
    }
    
    @discardableResult
    func withCornerRadius(_ radius: CGFloat) -> Self {
        layer.cornerRadius = radius
        layer.masksToBounds = true
        return self
    }
    
    @discardableResult
    func withIcon(named iconName: String, isSystemIcon: Bool = false, pointSize: CGFloat = 20.0, weight: UIImage.SymbolWeight = .regular, scale: UIImage.SymbolScale = .medium, color: UIColor = .black) -> Self {
        
        if isSystemIcon {
            let configuration = UIImage.SymbolConfiguration(pointSize: pointSize, weight: weight, scale: scale)
            var image = UIImage(systemName: iconName, withConfiguration: configuration)
            image = image?.withRenderingMode(.alwaysTemplate)
            setImage(image, for: .normal)
        } else {
            var image = UIImage(named: iconName)
            image = image?.withRenderingMode(.alwaysTemplate)
            setImage(image, for: .normal)
        }
        tintColor = color
        return self
    }
}

// MARK: - UITextField Extensions
extension UITextField {
    
    @discardableResult
    func withPlaceholder(_ placeholder: String) -> Self {
        self.placeholder = placeholder
        return self
    }
    
    @discardableResult
    func secured() -> Self {
        isSecureTextEntry = true
        return self
    }
}

// MARK: - UILabel Extensions
extension UILabel {
    
    @discardableResult
    func withText(_ text: String) -> Self {
        self.text = text
        return self
    }
    
    @discardableResult
    func withFont(_ size: CGFloat, fontName: String = "System") -> Self {
        if fontName == "System" {
            font = UIFont.systemFont(ofSize: size)
        } else {
            font = UIFont(name: fontName, size: size)
        }
        return self
    }

    @discardableResult
    func withFontWeight(_ weight: UIFont.Weight) -> Self {
        font = UIFont.systemFont(ofSize: font.pointSize, weight: weight)
        return self
    }
    
    @discardableResult
    func withTextColor(_ color: UIColor) -> Self {
        self.textColor = color
        return self
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
