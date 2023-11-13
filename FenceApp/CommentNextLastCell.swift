//
//  CommentNextLastCell.swift
//  FenceApp
//
//  Created by Woojun Lee on 11/10/23.
//

import UIKit

class CommentNextLastCell: UICollectionViewCell {
    
    static let identifier = "CommentNextLastCell"
    
    private let nextCommentLabel: UILabel = {
        let label = UILabel()
        label.text = "다음 댓글 더보기"
        return label
    }()
    
    private let LastCommentLabel: UILabel = {
        let label = UILabel()
        label.text = "마지막 댓글로"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        configureNextCommentLabel()
        configureLastCommentLabel()
    }
    
    private func configureNextCommentLabel() {
        contentView.addSubview(nextCommentLabel)
        nextCommentLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().inset(10)
            
            
        }
    }
    
    
    private func configureLastCommentLabel() {
        contentView.addSubview(LastCommentLabel)
        LastCommentLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview().inset(10)
            
        }
    }
}
