//
//  LostListViewController.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/16/23.
//

import UIKit
import SnapKit

class LostListViewController: UIViewController {
    
    private let lostListView = LostListView()
    
    let fireBaseLostService: FirebaseLostService
    var lostList: [LostResponseDTO] = []
    
    init(fireBaseLostService: FirebaseLostService) {
        self.fireBaseLostService = fireBaseLostService
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

        configureTableView()
        
        configureNavBar()
        
    }
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        navigationController?.isNavigationBarHidden = false
    //    }

    
    @objc func tapRightBarBtn(){
        let enrollVC = EnrollViewController()
        
        self.navigationController?.pushViewController(enrollVC, animated: true)
    }

    private func configureTableView(){
        lostListView.lostTableView.dataSource = self
        lostListView.lostTableView.delegate = self
    }
    
    func getLostList(){
        Task {
            do{
                lostList = fireBaseLostService.fet
            }catch{
                
            }
        }
    }
    

}


extension LostListViewController: LostListViewDelegate {
    // LostListViewDelegate 프로토콜 메서드 구현
    func didSelectRow(at indexPath: IndexPath) {
        let detailViewController = DetailViewController()
        // 데이터 설정 등을 수행
        navigationController?.pushViewController(detailViewController, animated: true)
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
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LostListViewCell", for: indexPath) as! LostListViewCell
        
        cell.titleLabel.text = "강아지를 찾아주세요"
        cell.dateLabel.text = "10 / 17 AM 3:30"
        cell.nickNameLabel.text = "나비주인"
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
//        delegate?.didSelectRow(at: indexPath)
        
    }
}

