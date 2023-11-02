//
//  LostListViewCell.swift
//  FenceApp
//
//  Created by t2023-m0067 on 10/17/23.
//

import UIKit
import SnapKit

class LostListViewCell: UITableViewCell {
    
    private let lostimgView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "person")
        img.clipsToBounds = true
        img.layer.borderWidth = 1
        img.layer.borderColor = UIColor.clear.cgColor
        return img
    }()
    
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "test"
        lb.font = UIFont.systemFont(ofSize: 22)
        lb.textColor = .black
        return lb
    }()
    
    private let dateLabel: UILabel = {
        let lb = UILabel()
        lb.text = "test"
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.textColor = .darkGray
        return lb
    }()
    
    private let nickNameLabel: UILabel = {
        let lb = UILabel()
        lb.text = "test"
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.textColor = .black
        return lb
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    func configure(lostPostImageUrl: String, lostPostTitle: String, lostPostDate: String, lostPostUserNickName: String) {
        lostimgView.kf.setImage(with: URL(string: lostPostImageUrl))
        titleLabel.text = lostPostTitle
        nickNameLabel.text = lostPostUserNickName
        
        let lostWriteDate = lostPostDate.getHowLongAgo()
        dateLabel.text = lostWriteDate
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        lostimgView.layer.cornerRadius = 15
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - AutoLayout
private extension LostListViewCell {
    
    func configureUI(){
        contentView.addSubviews(lostimgView, titleLabel, dateLabel, nickNameLabel)
        
        lostimgView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.equalTo(110)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(5)
            $0.leading.equalTo(lostimgView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview()

        }
        
        dateLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.leading.equalTo(lostimgView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview()
        }
        
        nickNameLabel.snp.makeConstraints {
            $0.leading.equalTo(lostimgView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().offset(-5)
        }

    }
}
