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
        lb.text = "거리 - 반경 5km 내 / 시간 - 1일 이내 / 동물 - 전체"
        return lb
    }()
    
    lazy var lostTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(LostListViewCell.self, forCellReuseIdentifier: "LostListViewCell")
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 3)
        tableView.separatorColor = .gray
        return tableView
    }()
    
    lazy var filterBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "line.3.horizontal.decrease.circle"), for: .normal)
        btn.contentVerticalAlignment = .fill
        btn.contentHorizontalAlignment = .fill
        btn.withShadow(color: .accent, opacity: 1, offset: CGSize(width: 0, height: 2), radius: 4)
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
    
    
    func setFilterLabel(within: Double, fromDate: Date, toDate: Date) {
        let result = toDate.timeIntervalSince1970 - fromDate.timeIntervalSince1970
        
        var resultDate = ""
        
        switch result {
        case 86400...:
            resultDate = "\(Int(result / 86400))일 이내"
        default:
            resultDate = "알 수 없는 오류"
        }
        
        filterLabel.text = "거리 - 반경 \(Int(within))km 내 / 시간 - \(resultDate)"
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
            $0.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
            
        }
        
        filterBtn.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(10)
            $0.width.equalTo(45)
            $0.height.equalTo(44)
            $0.bottom.equalToSuperview().inset(20)
        }
    }
}


