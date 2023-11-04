//
//  SectionHeaderView.swift
//  FenceApp
//
//  Created by t2023-m0067 on 11/2/23.
//

import UIKit
import SnapKit

class SectionHeaderView: UICollectionReusableView {
    
    static let identifier = "SectionHeaderView"
    
    let titleLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 25)
        lb.textColor = .darkGray
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        self.addSubview(titleLabel)

        titleLabel.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
        }
    }
}
