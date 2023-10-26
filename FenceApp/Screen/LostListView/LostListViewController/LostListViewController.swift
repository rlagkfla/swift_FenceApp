//
//  LostListViewController.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/16/23.
//

import UIKit
import SnapKit
import Kingfisher

class LostListViewController: UIViewController {
    
    private let lostListView = LostListView()
    
    let fireBaseLostService: FirebaseLostService
    let firebaseLostCommentService: FirebaseLostCommentService
    var lostList: [LostResponseDTO] = []
    
    let firebaseAuthService: FirebaseAuthService
    let firebaseUserService: FirebaseUserService
    
    init(fireBaseLostService: FirebaseLostService, firebaseLostCommentService: FirebaseLostCommentService, firebaseAuthService: FirebaseAuthService, firebaseUserService: FirebaseUserService) {
        self.fireBaseLostService = fireBaseLostService
        self.firebaseLostCommentService = firebaseLostCommentService
        self.firebaseAuthService = firebaseAuthService
        self.firebaseUserService = firebaseUserService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = lostListView
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
                
//        lostListView.delegate = self
        getLostList()
        
        configureTableView()
        
        configureNavBar()
       
    }
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        navigationController?.isNavigationBarHidden = false
    //    }

    
    @objc func tapRightBarBtn(){
        let enrollVC = EnrollViewController(firebaseAuthService: firebaseAuthService, firebaseLostService: fireBaseLostService, firebaseUserService: firebaseUserService)
        
        self.navigationController?.pushViewController(enrollVC, animated: true)
    }

    private func configureTableView(){
        lostListView.lostTableView.dataSource = self
        lostListView.lostTableView.delegate = self
    }
    
    func getLostList(){
        Task {
            do{
                lostList = try await fireBaseLostService.fetchLosts()
                lostListView.lostTableView.reloadData()
            }catch{
                print(error)
            }
        }
    }
    

}


extension LostListViewController {
    
    func configureNavBar() {
        self.navigationItem.title = "게시판"
        self.navigationController?.navigationBar.backgroundColor = .white
        // (네비게이션바 설정관련) iOS버전 업데이트 되면서 바뀐 설정:별:️:별:️:별:️
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground() // 불투명으로
        
        // 우측 버튼
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(tapRightBarBtn))
        
       // appearance.backgroundColor = .black // bartintcolor가 15버전부터 appearance로 설정하게끔 바뀜
//        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.orange]
//        appearance.titleTextAttributes = [.foregroundColor: UIColor.orange]
//        appearance.shadowColor = .clear
//        self.navigationController?.navigationBar.prefersLargeTitles = true
//        self.navigationController?.navigationBar.tintColor = .orange
//        self.navigationController?.navigationBar.standardAppearance = appearance
//        self.navigationController?.navigationBar.compactAppearance = appearance
//        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
//        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
}

extension LostListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return lostList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LostListViewCell", for: indexPath) as! LostListViewCell
        cell.lostimgView.kf.setImage(with: URL(string: lostList[indexPath.row].imageURL))
        cell.titleLabel.text = lostList[indexPath.row].title
        cell.dateLabel.text = "\(lostList[indexPath.row].lostDate)"
        cell.nickNameLabel.text = lostList[indexPath.row].userNickName
//        tableView.reloadData()
        return cell
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 여기에서 각 행에 대한 높이를 동적으로 반환합니다.
        return 110
    }
    
}

extension LostListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let DetailVC = DetailViewController(lostDTO: lostList[indexPath.row], firebaseCommentService: firebaseLostCommentService)
        self.navigationController?.pushViewController(DetailVC, animated: true)
    }
}

