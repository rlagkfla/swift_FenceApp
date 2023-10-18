//
//  LostListViewCell.swift
//  FenceApp
//
//  Created by t2023-m0067 on 10/17/23.
//

import UIKit
import SnapKit

class LostListViewCell: UITableViewCell {
    
    let lostimgView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "person")
//        img.clipsToBounds = true
        img.layer.cornerRadius = img.frame.size.width / 2
//        img.layer.cornerRadius = img.frame.height / 2
        img.layer.masksToBounds = true
        img.backgroundColor = .cyan
        return img
    }()
    
    let titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "test"
        lb.font = UIFont.systemFont(ofSize: 18)
        lb.textColor = .black
        lb.backgroundColor = .systemPink
        return lb
    }()
    
    let dateLabel: UILabel = {
        let lb = UILabel()
        lb.text = "test"
        lb.font = UIFont.systemFont(ofSize: 13)
        lb.textColor = .black
        lb.backgroundColor = .green
        return lb
    }()
    
    let nickNameLabel: UILabel = {
        let lb = UILabel()
        lb.text = "test"
        lb.font = UIFont.systemFont(ofSize: 13)
        lb.textColor = .black
        lb.backgroundColor = .yellow
        return lb
    }()
    
    lazy var lbStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [titleLabel, dateLabel, nickNameLabel])
        sv.axis = .vertical
        sv.spacing = 5
//        sv.alignment = .fill
//        sv.distribution = .fill
        sv.layoutMargins = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 5)
        sv.isLayoutMarginsRelativeArrangement = true
        return sv
    }()
    
    lazy var totalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [lostimgView, lbStackView])
        sv.axis = .horizontal
        sv.spacing = 10
        sv.alignment = .fill
        sv.distribution = .fill
        return sv
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    
}

extension LostListViewCell {
    
    func configureUI(){
        self.addSubview(totalStackView)
        
//        lbStackView.snp.makeConstraints {
//            $0.top.leading.trailing.bottom.equalToSuperview()
//        }
        
        lostimgView.snp.makeConstraints {
            $0.width.equalTo(110)
        }
        
//        titleLabel.snp.makeConstraints {
////            $0.top.leading.trailing.equalToSuperview()
//            $0.height.equalTo(20)
//        }
//        
//        dateLabel.snp.makeConstraints {
//            $0.height.equalTo(20)
//        }
        
//        nickNameLabel.snp.makeConstraints {
//            $0.top.equalTo(dateLabel.snp.bottom).offset(10)
//        }
        
        totalStackView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        

    }
}
