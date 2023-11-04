//
//  MyInfoViewController.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/16/23.
//


import UIKit

class MyInfoViewController: UIViewController {
    
    //MARK: - Properties
    
    var previousNickname: String = ""
    var previousMemo: String = ""
    var previousImage: UIImage?
    
    let firebaseAuthService: FirebaseAuthService
    let firebaseLostService: FirebaseLostService
    let firebaseFoundService: FirebaseFoundService
    var lostList: [Lost] = []
    var foundList: [Found] = []
    
    var logOut: ( () -> Void )?
    
    let user = CurrentUserInfo.shared.currentUser!
    
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 60
        iv.image = UIImage(named: "profile_image")
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private let nickname: UILabel = {
        let label = UILabel()
        //        label.backgroundColor = .blue
        label.text = "닉네임"
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private let memo: UILabel = {
        let label = UILabel()
        //        label.backgroundColor = .red
        label.text = "간단한 메모"
        return label
    }()
    
    private lazy var editProfileButton: UIButton = {
        let button = UIButton()
        button.setTitle("프로필 편집", for: .normal)
        button.setTitleColor(.white, for: .normal) 
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 10.0
        button.layer.borderColor = UIColor.color2.cgColor
        button.backgroundColor = UIColor.color1
        button.addTarget(self, action: #selector(editProfile), for: .touchUpInside)
        
        if let titleLabel = button.titleLabel {
            let attributes: [NSAttributedString.Key: Any] = [
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: titleLabel.font.pointSize)
            ]
            let attributedString = NSAttributedString(string: "프로필 편집", attributes: attributes)
            button.setAttributedTitle(attributedString, for: .normal)
        }
        return button
    }()
    
    private let borderLine: UILabel = {
        let lb = UILabel()
        lb.layer.borderWidth = 1
        lb.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        return lb
    }()

    private lazy var lostCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .lightGray
        collectionView.register(MyInfoCollectionViewCell.self, forCellWithReuseIdentifier: MyInfoCollectionViewCell.identifier)
        collectionView.isScrollEnabled = true
        return collectionView
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureNavigationBar()
        
        getListenToLosts()
        getListenToFounds()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]
    }
    
    init(firebaseLostService: FirebaseLostService, firebaseFoundService: FirebaseFoundService, firebaseAuthService: FirebaseAuthService) {
        self.firebaseLostService = firebaseLostService
        self.firebaseFoundService = firebaseFoundService
        self.firebaseAuthService = firebaseAuthService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Actions
    
    @objc func logoutTapped() {
        let alertController = UIAlertController(title: "로그아웃", message: "로그아웃하시겠습니까?", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default) { (action) in
            
            self.logOut?()
            print("로그아웃 확인됨")
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @objc func editProfile() {
        // let view = EditViewController()
        // view.delegate = self
        // navigationController?.pushViewController(view, animated: true)
        let editViewController = EditViewController()
        editViewController.delegate = self
        editViewController.previousNickname = self.nickname.text ?? ""
        editViewController.previousMemo = self.memo.text ?? ""
        editViewController.previousImage = self.profileImageView.image
        
        editViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(editViewController, animated: true)
    }
    
    
    //MARK: - Helpers
    
    private func getListenToLosts() {
        
        firebaseLostService.listenToUpdateOn(userIdentifier: user.identifier) { [weak self] result in
            
            switch result {
                
            case .failure(let error):
                print(error)
            case .success(let lostResponseDTOs):
                
                self?.lostList = LostResponseDTOMapper.makeLosts(from: lostResponseDTOs)
                
                self?.lostCollectionView.reloadData()
            }
        }
    }
    
    private func getListenToFounds() {
        
        firebaseFoundService.listenToUpdateOn(userIdentifier: user.identifier) { [weak self] result in
            
            switch result {
                
            case .failure(let error):
                print(error)
                
            case .success(let foundResponseDTOs):
                
                self?.foundList = FoundResponseDTOMapper.makeFounds(from: foundResponseDTOs)
                
                self?.lostCollectionView.reloadData()
            }
        }
    }

    func setNickName() {
        nickname.text = user.nickname
    }
    func setImage() {
        
        guard let url = URL(string: user.profileImageURL ) else {
            return
        }
        profileImageView.kf.setImage(with: url)
    }
    private func configureNavigationBar() {
        navigationItem.title = "마이페이지"
        
        if let titleTextAttributes = navigationController?.navigationBar.titleTextAttributes {
            var attributes = titleTextAttributes
            attributes[NSAttributedString.Key.foregroundColor] = UIColor.black
            navigationController?.navigationBar.titleTextAttributes = attributes
        } else {
            let attributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            navigationController?.navigationBar.titleTextAttributes = attributes
        }
        
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        let logoutImage = UIImage(systemName: "escape")?.withConfiguration(largeConfig)
        let logoutButton = UIBarButtonItem(image: logoutImage, style: .plain, target: self, action: #selector(logoutTapped))
        logoutButton.tintColor = UIColor.color1
        navigationItem.rightBarButtonItem = logoutButton
    }
    
    
    
}
//MARK: - EditViewController Delegate

extension MyInfoViewController: EditViewControllerDelegate {
    func didSaveProfileInfo(nickname: String, image: UIImage) {
        DispatchQueue.main.async {
            self.nickname.text = nickname
            self.profileImageView.image = image
        }
    }
}

//MARK: - TextField Delegate

extension MyInfoViewController: UITextFieldDelegate {
    
}

//MARK: - Collectionview DataSource



extension MyInfoViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.identifier, for: indexPath) as! SectionHeaderView
           
            headerView.titleLabel.text = sectionTitles[indexPath.section]
            return headerView
        } else {
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        section == 0 ? lostList.count : foundList.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyInfoCollectionViewCell.identifier, for: indexPath) as! MyInfoCollectionViewCell
        
        if indexPath.section == 0 {
            
            let urlString = lostList[indexPath.row].imageURL
            
            cell.setImage(urlString: urlString)
            
        } else {
            
            let urlString = foundList[indexPath.row].imageURL
            
            cell.setImage(urlString: urlString)
        }
        
        return cell
    }
}


//MARK: - CollectionView FlowLayout


extension MyInfoViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - 4)/3, height: (collectionView.bounds.width - 4)/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 50, left: 0, bottom: 10, right: 0)
        } else {
            return UIEdgeInsets(top: 40, left: 0, bottom: 20, right: 0)
        }
    }
}

//MARK: - UI

extension MyInfoViewController {
    
    
    private func configureUI() {
        
        configureSelf()
        configureProfileImage()
        configureNickName()
        configureMemo()
        configureEditProfileButton()
        configureLostCollectionView()
    }
    
    private func configureSelf() {
        view.backgroundColor = .white
    }
    
    private func configureProfileImage() {
        view.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
    private func configureNickName(){
        view.addSubview(nickname)
        nickname.translatesAutoresizingMaskIntoConstraints = false
        nickname.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 40).isActive = true
        nickname.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 45).isActive = true
        nickname.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
    }
    
    private func configureMemo(){
        view.addSubview(memo)
        memo.translatesAutoresizingMaskIntoConstraints = false
        memo.leadingAnchor.constraint(equalTo: nickname.leadingAnchor).isActive = true
        memo.topAnchor.constraint(equalTo: nickname.bottomAnchor, constant: 16).isActive = true
        memo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
    }
    
    private func configureEditProfileButton() {
        view.addSubview(editProfileButton)
        editProfileButton.translatesAutoresizingMaskIntoConstraints = false
        editProfileButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        editProfileButton.topAnchor.constraint(equalTo: nickname.bottomAnchor, constant: 80).isActive = true
        editProfileButton.widthAnchor.constraint(equalToConstant: 180).isActive = true
        editProfileButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }

    
    private func configureLostCollectionView(){
        view.addSubview(lostCollectionView)
        lostCollectionView.translatesAutoresizingMaskIntoConstraints = false
        lostCollectionView.topAnchor.constraint(equalTo: editProfileButton.bottomAnchor, constant: 30).isActive = true
        lostCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        lostCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        lostCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    
}
