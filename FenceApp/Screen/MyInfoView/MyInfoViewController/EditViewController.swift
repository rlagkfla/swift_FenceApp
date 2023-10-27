//
//  EditViewController.swift
//  FenceApp
//
//  Created by t2023-m0063 on 10/21/23.
//

import UIKit

protocol EditViewControllerDelegate: AnyObject {
    func didSaveProfileInfo(nickname: String, memo: String, image: UIImage)
}

class EditViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
   

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
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let memoTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "메모"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    weak var delegate: EditViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemPink
        
        setupProfileImageView()
        setupNicknameTextField()
        setupMemoTextField()
        setupNavigationBar()
        addTapGesture()
    }
    
    func setupProfileImageView() {
        view.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
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
    }
    
    func setupMemoTextField() {
        view.addSubview(memoTextField)
        memoTextField.topAnchor.constraint(equalTo: nicknameTextField.bottomAnchor, constant: 30).isActive = true
        memoTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 70).isActive = true
        memoTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -70).isActive = true
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = "프로필 편집"
        if let font = UIFont(name: "Arial-BoldMT", size: 24) {
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: font]
        }
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelButtonTapped))
        let doneButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(doneButtonTapped))
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
        if presentingViewController != nil {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func doneButtonTapped() {
        if let nickname = nicknameTextField.text, let memo = memoTextField.text, let image = profileImageView.image  {
            delegate?.didSaveProfileInfo(nickname: nickname, memo: memo, image: image)
           }
           if presentingViewController != nil {
               dismiss(animated: true, completion: nil)
           } else {
               navigationController?.popViewController(animated: true)
           }
       }
    
    func addTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

