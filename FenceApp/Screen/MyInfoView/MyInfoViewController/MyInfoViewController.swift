//
//  MyInfoViewController.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/16/23.
//

//import UIKit
//
//class MyInfoViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
//
//
import UIKit

class MyInfoViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, EditViewControllerDelegate {

    let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 60
        iv.image = UIImage(named: "profile_image")
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    let nickname: UILabel = {
        let label = UILabel()
        label.backgroundColor = .blue
        label.text = "닉네임"
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    let memo: UILabel = {
        let label = UILabel()
        label.backgroundColor = .red
        label.text = "간단한 메모"
        return label
    }()
    
    private lazy var editProfileButton: UIButton = {
        let button = UIButton()
        button.setTitle("프로필 편집", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 10.0
        button.layer.borderColor = UIColor.blue.cgColor
        button.addTarget(self, action: #selector(editProfile), for: .touchUpInside)
        return button
    }()
    
    lazy var lostCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .lightGray
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.isScrollEnabled = true
        return collectionView
    }()
    
    var editButtonTopConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureUI()
        configureNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]
    }
    
    private func configureUI(){
        configureProfileImage()
        configureNickName()
        configureMemo()
        configureEditProfileButton()
        configureLostCollectionView()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "마이페이지"
    }
    
    private func configureLostCollectionView(){
        view.addSubview(lostCollectionView)
        lostCollectionView.translatesAutoresizingMaskIntoConstraints = false
        lostCollectionView.topAnchor.constraint(equalTo: editProfileButton.bottomAnchor, constant: 30).isActive = true
        lostCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        lostCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        lostCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -self.tabBarController!.tabBar.frame.height).isActive = true
    }
    
    private func configureEditProfileButton() {
        view.addSubview(editProfileButton)
        editProfileButton.translatesAutoresizingMaskIntoConstraints = false
        editButtonTopConstraint = editProfileButton.topAnchor.constraint(equalTo: memo.bottomAnchor, constant: 45)
        editButtonTopConstraint?.isActive = true
        editProfileButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        editProfileButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        editProfileButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func configureNickName(){
        view.addSubview(nickname)
        nickname.translatesAutoresizingMaskIntoConstraints = false
        nickname.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 40).isActive = true
        nickname.topAnchor.constraint(equalTo: profileImageView.topAnchor, constant: 30).isActive = true
        nickname.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
    }
    
    private func configureMemo(){
        view.addSubview(memo)
        memo.translatesAutoresizingMaskIntoConstraints = false
        memo.leadingAnchor.constraint(equalTo: nickname.leadingAnchor).isActive = true
        memo.topAnchor.constraint(equalTo: nickname.bottomAnchor, constant: 16).isActive = true
        memo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
    }
    
    private func configureProfileImage() {
        view.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
    }

    @objc func editProfile() {
        let view = EditViewController()
        view.delegate = self
        navigationController?.pushViewController(view, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - 4)/3, height: (collectionView.bounds.width - 4)/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        
        if indexPath.section == 0 {
            cell.backgroundColor = .systemPink
            if indexPath.item == 0 {
                let lostLabel = UILabel()
                lostLabel.text = "Lost"
                lostLabel.textColor = .black
                lostLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
                lostLabel.translatesAutoresizingMaskIntoConstraints = false
                cell.addSubview(lostLabel)
                lostLabel.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
                lostLabel.bottomAnchor.constraint(equalTo: cell.topAnchor, constant: -10).isActive = true
            }
        }
        
        if indexPath.section == 1 {
            cell.backgroundColor = .color1
            if indexPath.item == 0 {
                let foundLabel = UILabel()
                foundLabel.text = "Found"
                foundLabel.textColor = .black
                foundLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
                foundLabel.translatesAutoresizingMaskIntoConstraints = false
                cell.addSubview(foundLabel)
                foundLabel.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
                foundLabel.bottomAnchor.constraint(equalTo: cell.topAnchor, constant: -10).isActive = true
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 50, left: 0, bottom: 10, right: 0)
        } else {
            return UIEdgeInsets(top: 40, left: 0, bottom: 20, right: 0)
        }
    }

    func didSaveProfileInfo(nickname: String, memo: String, image: UIImage) {
        DispatchQueue.main.async {
            self.nickname.text = nickname
            self.memo.text = memo
            self.profileImageView.image = image
        }
    }
}
