import UIKit
import SnapKit

class MessageViewController: UIViewController {
    
    private let textField = UITextField()
    private let sendButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        layoutViews()
    }

    private func setupViews() {
        view.backgroundColor = .white
        view.handleKeyboardAdjustment(adjustmentFactor: 0.4)

        textField.borderStyle = .roundedRect
        view.addSubview(textField)

    
        sendButton.setTitle("Send", for: .normal)
        sendButton.backgroundColor = .blue
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
        view.addSubview(sendButton)
    }

    private func layoutViews() {
    
        textField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(40)
        }

        sendButton.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(80)
            $0.height.equalTo(40)
        }
    }

    @objc private func sendButtonTapped() {
        print("Send button tapped with text: \(textField.text ?? "")")
    }
}
