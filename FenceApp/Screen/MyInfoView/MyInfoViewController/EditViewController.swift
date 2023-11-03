//
//  EditViewController.swift
//  FenceApp
//
//  Created by t2023-m0063 on 10/21/23.
//

import UIKit

protocol EditViewControllerDelegate: AnyObject {
    func didSaveProfileInfo(nickname: String, image: UIImage)
}

class EditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // EditViewController에 추가된 변수들을 처리하기 위한 프로퍼티들
    var previousNickname: String = ""
    var previousMemo: String = ""
    var previousImage: UIImage?

    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 60
        iv.backgroundColor = .lightGray
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    let nicknameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "닉네임"
        textField.backgroundColor = .systemGray6
//        textField.layer.addBorder([.bottom], color: UIColor(hexCode: "5DDFDE"), width: 3)
//        textField.layer.borderColor = UIColor(hexCode: "5DDFDE").cgColor
//        textField.layer.borderWidth = 2
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    
    weak var delegate: EditViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        view.handleKeyboardAdjustment(adjustmentFactor: 0.25)
        
        nicknameTextField.text = previousNickname
        profileImageView.image = previousImage
        
        setupProfileImageView()
        setupNicknameTextField()
//        setupMemoTextField()
        setupNavigationBar()
        addTapGesture()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nicknameTextField.layer.addBorder([.bottom], color: UIColor.color1, width: 3.0)

    }
    
    func setupProfileImageView() {
        view.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true
//        profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectProfileImage))
        profileImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func setupNicknameTextField() {
        view.addSubview(nicknameTextField)
        nicknameTextField.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 50).isActive = true
        nicknameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70).isActive = true
        nicknameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -70).isActive = true
        nicknameTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
//    func setupMemoTextField() {
//        view.addSubview(memoTextField)
//        memoTextField.topAnchor.constraint(equalTo: nicknameTextField.bottomAnchor, constant: 30).isActive = true
//        memoTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70).isActive = true
//        memoTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -70).isActive = true
//    }
    
    func setupNavigationBar() {
        self.navigationItem.title = "프로필 편집"
        
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelButtonTapped))
        cancelButton.tintColor = .color2

        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(doneButtonTapped))
        doneButton.tintColor = .color2

        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.rightBarButtonItem = doneButton
    }

    
    @objc func selectProfileImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            profileImageView.image = selectedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func cancelButtonTapped() {
//        if presentingViewController != nil {
//            dismiss(animated: true, completion: nil)
//        } else {
//            navigationController?.popViewController(animated: true)
//        }
        navigationController?.popViewController(animated: true)

    }
    
    @objc func doneButtonTapped() {
        if let nickname = nicknameTextField.text, let image = profileImageView.image  {
            delegate?.didSaveProfileInfo(nickname: nickname, image: image)
        }
        
//           if presentingViewController != nil {
//               dismiss(animated: true, completion: nil)
//           } else {
//               navigationController?.popViewController(animated: true)
//           }
        
        navigationController?.popViewController(animated: true)

       }
    
    func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension CALayer {
    func addBorder(_ arr_edge: [UIRectEdge], color: UIColor, width: CGFloat) {
        for edge in arr_edge {
            let border = CALayer()
            switch edge {
            case UIRectEdge.top:
                border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)
                break
            case UIRectEdge.bottom:
                border.frame = CGRect.init(x: 0, y: frame.height - width, width: frame.width, height: width)
                break
            case UIRectEdge.left:
                border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
                break
            case UIRectEdge.right:
                border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
                break
            default:
                break
            }
            border.backgroundColor = color.cgColor;
            self.addSublayer(border)
        }
    }
}
