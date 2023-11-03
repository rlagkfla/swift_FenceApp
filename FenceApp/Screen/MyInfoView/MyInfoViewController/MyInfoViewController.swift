//
//  MyInfoViewController.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/16/23.
//


import UIKit
import SnapKit

class MyInfoViewController: UIViewController {
    
    //MARK: - Properties
    
    private let sectionTitles = ["LOST", "FOUND"]
    
    var previousNickname: String = ""
    var previousMemo: String = ""
    var previousImage: UIImage?
    
    let firebaseLostService: FirebaseLostService
    let firebaseFoundService: FirebaseFoundService
    var lostList: [LostResponseDTO] = []
    var foundList: [FoundResponseDTO] = []
    
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
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
//    private let memo: UILabel = {
//        let label = UILabel()
//        //        label.backgroundColor = .red
//        label.text = "간단한 메모"
//        label.textColor = UIColor.color1
//        return label
//    }()
    
    private lazy var editProfileButton: UIButton = {
        let button = UIButton()
        button.setTitle("프로필 편집", for: .normal)
        button.setTitleColor(.color1, for: .normal)
        button.layer.borderWidth = 1.0
        button.layer.cornerRadius = 10.0
        button.layer.borderColor = UIColor.color1.cgColor
        button.addTarget(self, action: #selector(editProfile), for: .touchUpInside)
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
        collectionView.backgroundColor = .white
        collectionView.register(MyInfoCollectionViewCell.self, forCellWithReuseIdentifier: MyInfoCollectionViewCell.identifier)
        collectionView.register(SectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SectionHeaderView.identifier)
        collectionView.isScrollEnabled = true
        return collectionView
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       Task {
            
            do {
                
                configureUI()
                
                configureNavigationBar()
                
                try await getLosts()
                
                try await getFounds()
                
                lostCollectionView.reloadData()
                
            } catch {
                print(error)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]
        configureNavigationBar()
    }
    
    init(firebaseLostService: FirebaseLostService, firebaseFoundService: FirebaseFoundService) {
        self.firebaseLostService = firebaseLostService
        self.firebaseFoundService = firebaseFoundService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Actions
    
    @objc func logoutTapped() {
        let alertController = UIAlertController(title: "로그아웃", message: "로그아웃하시겠습니까?", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default) { (action) in
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
//        editViewController.previousMemo = self.memo.text ?? ""
        editViewController.previousImage = self.profileImageView.image
        
        editViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(editViewController, animated: true)
    }
    
    
    //MARK: - Helpers
    
    private func getLosts() async throws {
        
        lostList = try await firebaseLostService.fetchLosts()
    }
    
    private func getFounds() async throws {
        
        foundList = try await firebaseFoundService.fetchFounds()
    }
    
    
    private func configureNavigationBar() {
        navigationItem.title = "마이페이지"
        
        if let titleTextAttributes = navigationController?.navigationBar.titleTextAttributes {
            var attributes = titleTextAttributes
            attributes[NSAttributedString.Key.foregroundColor] = UIColor.black
            navigationController?.navigationBar.titleTextAttributes = attributes
        } else {
            let attributes = [NSAttributedString.Key.foregroundColor: UIColor.color2]
            navigationController?.navigationBar.titleTextAttributes = attributes
        }
        
        let logoutImage = UIImage(systemName: "escape")
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
//                self.memo.text = memo
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

            // 섹션 제목을 설정
            headerView.titleLabel.text = sectionTitles[indexPath.section]
            return headerView
        } else {
            // 다른 경우 (footer, 등)에 대한 처리
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return section == 0 ? lostList.count : foundList.count
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
        let cellWidth = (collectionView.bounds.width - 10 - 10 - 2 * 4) / 3 // (컬렉션 뷰 너비 - 좌/우 inset - (셀 간 간격 * 4)) / 3
        return CGSize(width: cellWidth, height: cellWidth) // 정사각형 셀
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 50) // 원하는 높이로 설정
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 20, right: 10)
    }
    
}

//MARK: - UI

extension MyInfoViewController {
    

    private func configureUI() {
        
        configureSelf()
        configureProfileImage()
        configureNickName()
//        configureMemo()
        configureEditProfileButton()
        configureLine()
        configureLostCollectionView()
    }
    
    private func configureSelf() {
        view.backgroundColor = .white
    }
    
    private func configureProfileImage() {
        view.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 120).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
    private func configureNickName(){
        view.addSubview(nickname)
        nickname.translatesAutoresizingMaskIntoConstraints = false
        nickname.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 40).isActive = true
        nickname.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60).isActive = true
        nickname.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
        
    }
    
//    private func configureMemo(){
//        view.addSubview(memo)
//        memo.translatesAutoresizingMaskIntoConstraints = false
//        memo.leadingAnchor.constraint(equalTo: nickname.leadingAnchor).isActive = true
//        memo.topAnchor.constraint(equalTo: nickname.bottomAnchor, constant: 16).isActive = true
//        memo.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
//        
//    }
    
    private func configureEditProfileButton() {
        view.addSubview(editProfileButton)
        editProfileButton.translatesAutoresizingMaskIntoConstraints = false
        editProfileButton.topAnchor.constraint(equalTo: nickname.bottomAnchor, constant: 80).isActive = true
        editProfileButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
//        editProfileButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        editProfileButton.widthAnchor.constraint(equalToConstant: 180).isActive = true
        editProfileButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func configureLine(){
        view.addSubview(borderLine)
        
        borderLine.snp.makeConstraints {
            $0.top.equalTo(editProfileButton.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(0.7)
        }
    }
    
    private func configureLostCollectionView(){
        view.addSubview(lostCollectionView)
        lostCollectionView.translatesAutoresizingMaskIntoConstraints = false
        lostCollectionView.topAnchor.constraint(equalTo: borderLine.bottomAnchor, constant: 5).isActive = true
        lostCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        lostCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        lostCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
 
}
