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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.backgroundColor = .blue
        
//        setupNaviBar()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        navigationController?.isNavigationBarHidden = false
//    }

    func setupNaviBar() {
        title = "test11"
        // (네비게이션바 설정관련) iOS버전 업데이트 되면서 바뀐 설정:별:️:별:️:별:️
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground() // 불투명으로
       // appearance.backgroundColor = .black // bartintcolor가 15버전부터 appearance로 설정하게끔 바뀜
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.orange]
        appearance.titleTextAttributes = [.foregroundColor: UIColor.orange]
        appearance.shadowColor = .clear
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.tintColor = .orange
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.compactAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }

}
