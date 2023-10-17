//
//  LostListView.swift
//  FenceApp
//
//  Created by t2023-m0067 on 10/16/23.
//

import UIKit
import SnapKit

class LostListView: UIView {

//    let navigationBar : UINavigationBar = {
//        let nav = UINavigationBar()
//        nav.translatesAutoresizingMaskIntoConstraints = false
////        nav.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 150)
//        let navItem = UINavigationItem(title: "Lost")
//        let rightButton = UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style: .plain, target: self, action: #selector(tapPlusBtn))
//        navItem.rightBarButtonItem = rightButton
//        nav.setItems([navItem], animated: true)
//        
//        return nav
//    }()
    
    let filterLabel: UILabel = {
        let lb = UILabel()
//        lb.textColor = UIColor(red: 67, green: 67, blue: 67, alpha: 1)
        lb.textColor = .darkGray
        lb.font = UIFont.systemFont(ofSize: 13)
        lb.text = "거리 - 반경 5km 내 / 시간 - 3시간 이내 / 동물 - 전체"
        lb.translatesAutoresizingMaskIntoConstraints = false
        
        return lb
    }()
    
    lazy var lostTableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(LostListViewCell.self, forCellReuseIdentifier: "LostListViewCell")
        tableView.backgroundColor = .blue
        
        return tableView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension LostListView {
    
    func configureUI(){
        self.addSubview(filterLabel)
        self.addSubview(lostTableView)
        
        
        filterLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(105)
            $0.leading.equalToSuperview().offset(23)
            $0.trailing.equalToSuperview().offset(-23)
        }
        
        lostTableView.snp.makeConstraints {
            $0.top.equalTo(filterLabel.snp.bottom).offset(7)
            $0.leading.equalToSuperview().offset(18)
            $0.trailing.equalToSuperview().offset(-18)
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-20)
            
        }
        
        
        
    }
    
//    func configureNavi(){
//        self.addSubview(navigationBar)
//        
//        navigationBar.snp.makeConstraints {
//            $0.top.leading.trailing.equalToSuperview()
//            $0.height.equalTo(150)
//        }
//    }
//    
//    @objc func tapPlusBtn(){
//        print("click")
//    }
    
   
    
}


extension LostListView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LostListViewCell", for: indexPath) as! LostListViewCell
        
        cell.testLabel.text = "test11"
        tableView.reloadData()
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}
