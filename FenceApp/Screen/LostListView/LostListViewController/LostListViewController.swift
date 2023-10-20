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
    
    
    override func loadView() {
        view = lostListView
    }
    
    // 임시 버튼
    lazy var testBtnnn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "plus"), for: .normal)
        btn.addTarget(self, action: #selector(tapPlusBtns), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.backgroundColor = .white
//        self.navigationController?.navigationItem.title = "test"
//        self.navigationItem.title = "test"
        view.addSubview(testBtnnn)
        
        testBtnnn.snp.makeConstraints {
            $0.top.equalToSuperview().offset(100)
            $0.trailing.equalToSuperview().offset(-13)
        }
        
        
        // 클로저를 설정하여 셀 선택 시 이벤트 처리
        lostListView.didSelectRow = { [weak self] indexPath in
        let detailViewController = DetailViewController()
        // 데이터 설정 등을 수행
        self?.navigationController?.pushViewController(detailViewController, animated: true)
        }
        
    }
    
    @objc func tapPlusBtns(){
        let enrollVC = EnrollViewController()
        
        self.navigationController?.pushViewController(enrollVC, animated: true)
    }
//    override func viewWillAppear(_ animated: Bool) {
//        navigationController?.isNavigationBarHidden = false
//    }

//    func setupNaviBar() {
//        title = "test11"
//        // (네비게이션바 설정관련) iOS버전 업데이트 되면서 바뀐 설정:별:️:별:️:별:️
//        let appearance = UINavigationBarAppearance()
//        appearance.configureWithOpaqueBackground() // 불투명으로
//       // appearance.backgroundColor = .black // bartintcolor가 15버전부터 appearance로 설정하게끔 바뀜
//        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.orange]
//        appearance.titleTextAttributes = [.foregroundColor: UIColor.orange]
//        appearance.shadowColor = .clear
//        self.navigationController?.navigationBar.prefersLargeTitles = true
//        self.navigationController?.navigationBar.tintColor = .orange
//        self.navigationController?.navigationBar.standardAppearance = appearance
//        self.navigationController?.navigationBar.compactAppearance = appearance
//        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
//        self.navigationItem.hidesSearchBarWhenScrolling = false
//    }

}


