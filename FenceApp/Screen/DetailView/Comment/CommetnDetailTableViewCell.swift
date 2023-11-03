//
//  CommetnDetailTableViewCell.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/19/23.
//

import UIKit

class CommentDetailTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    static let identifier: String = "CommentDetailCell"
    
    // MARK: - UI Properties
    private let commentUserProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .yellow
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleToFill
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.clear.cgColor
        return imageView
    }()
    
    private let commenterNickName: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let commentDate: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .right
        return label
    }()
    
    private let commentTextLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    // MARK: - Life Cycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        commentUserProfileImageView.layer.cornerRadius = 15
    }
    
    func configureCell(commentUserNickName: String, commentUserProfileImageUrl: String, commentDescription: String, commentTime: String) {
        commenterNickName.text = commentUserNickName
        commentUserProfileImageView.kf.setImage(with: URL(string: commentUserProfileImageUrl))
        commentTextLabel.text = commentDescription
        let commentDateFormatter = commentTime.getHowLongAgo()
        commentDate.text = commentDateFormatter
    }
}

// MARK: - AutoLayout
private extension CommentDetailTableViewCell {
    func configureUI() {
        configureCommentUserProfileImageView()
        configureCommenterNickName()
        configureCommentDate()
        configureCommentTextLabel()
    }
    
    func configureCommentUserProfileImageView() {
        contentView.addSubview(commentUserProfileImageView)
        
        commentUserProfileImageView.snp.makeConstraints {
            
            $0.leading.equalToSuperview().offset(10)
            $0.width.height.equalTo(30)
        }
    }
    
    func configureCommenterNickName() {
        contentView.addSubview(commenterNickName)
        
        commenterNickName.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(commentUserProfileImageView.snp.trailing).offset(10)
            $0.width.equalTo(200)
            $0.height.equalTo(16)
        }
    }
    
    func configureCommentDate() {
        contentView.addSubview(commentDate)
        
        commentDate.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
            $0.width.equalTo(80)
            $0.height.equalTo(16)
        }
    }
    
    func configureCommentTextLabel() {
        contentView.addSubview(commentTextLabel)
        
        commentTextLabel.snp.makeConstraints {
            $0.top.equalTo(commenterNickName.snp.bottom).offset(3)
            $0.leading.equalTo(commentUserProfileImageView.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(10)
            $0.bottom.equalToSuperview().inset(5)
        }
    }
}
