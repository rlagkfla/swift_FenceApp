//
//  LostListView.swift
//  FenceApp
//
//  Created by t2023-m0067 on 10/16/23.
//

import UIKit
import SnapKit

protocol lostListViewDelegate: AnyObject {
    func tapFilterButton()
}

class LostListView: UIView {
    
    weak var delegate: lostListViewDelegate?
    
    private let filterLabel: UILabel = {
        let lb = UILabel()
        lb.textColor = .darkGray
        lb.font = UIFont.systemFont(ofSize: 13)
        lb.text = "거리 - 반경 5km 내 / 시간 - 3시간 이내 / 동물 - 전체"
        return lb
    }()
    
    lazy var lostTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(LostListViewCell.self, forCellReuseIdentifier: "LostListViewCell")
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0.5, left: 10, bottom: 0.5, right: 10)
        tableView.separatorColor = .gray
        return tableView
    }()
    
    lazy var filterBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "line.3.horizontal.decrease.circle"), for: .normal)
        btn.contentVerticalAlignment = .fill
        btn.contentHorizontalAlignment = .fill
        btn.addTarget(self, action: #selector(tapFilterBtutton), for: .touchUpInside)
        return btn
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func tapFilterBtutton(){
        delegate?.tapFilterButton()
    }
    
}

extension LostListView {
    
    func configureUI(){
        self.addSubview(filterLabel)
        self.addSubview(lostTableView)
        self.addSubview(filterBtn)

        filterLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(105)
            $0.leading.equalToSuperview().offset(23)
            $0.trailing.equalToSuperview().offset(-23)
        }
        
        lostTableView.snp.makeConstraints {
            $0.top.equalTo(filterLabel.snp.bottom).offset(7)
            $0.leading.equalToSuperview().offset(18)
            $0.trailing.equalToSuperview().offset(-18)
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).offset(-30)
            
        }
        
        filterBtn.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(10)
            $0.width.equalTo(43)
            $0.height.equalTo(42)
            $0.bottom.equalToSuperview().inset(20)
        }
        
    }
}


