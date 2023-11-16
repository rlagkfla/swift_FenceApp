//
//  CommentNextLastCell.swift
//  FenceApp
//
//  Created by Woojun Lee on 11/10/23.
//

import UIKit

enum CommentTo {
    case normal
    case next
    case last
    case write
}

class CommentNextLastCell: UICollectionViewCell {
    
    static let identifier = "CommentNextLastCell"
    
    var nextCommentLabelTapped: ((CommentTo) -> Void)?
    
    private lazy var nextCommentLabel: UILabel = {
        let label = UILabel()
        label.text = "다음 댓글 더보기"
        label.font = UIFont.systemFont(ofSize: 13)
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(nextLabelTapped)))
        return label
    }()
    
    private lazy var LastCommentLabel: UILabel = {
        let label = UILabel()
        label.text = "마지막 댓글로"
        label.font = UIFont.systemFont(ofSize: 13)
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(lastLabelTapped)))
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func nextLabelTapped() {
        nextCommentLabelTapped?(.next)
    }
    
    @objc func lastLabelTapped() {
        nextCommentLabelTapped?(.last)
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
