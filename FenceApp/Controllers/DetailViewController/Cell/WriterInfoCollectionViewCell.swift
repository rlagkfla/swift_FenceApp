//
//  WriterInfoTableViewCell.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/17/23.
//

import UIKit
import SnapKit

class WriterInfoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let identifier: String = "WriterInfoCell"

    // MARK: - UI Properties
    private let writerProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        return imageView
    }()
    
    private let writerNickNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .left
        return label
    }()
    
    private let postWriteTimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .systemGray2
        label.textAlignment = .right
        return label
    }()
    
    private lazy var chattingButton: UIButton = {
       let button = UIButton()
        button.setTitle("채팅하기", for: .normal)
        button.backgroundColor = CustomColor.pointColor
        button.layer.cornerRadius = 3
        button.addTarget(self, action: #selector(chattingButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var moveToChatting: ( () -> Void )?
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    override func layoutSubviews() {
        writerProfileImageView.layer.cornerRadius = 25
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func chattingButtonTapped() {
        moveToChatting?()
    }
    
    func configureCell(userNickName: String, userProfileImageURL: String, postTime: String) {
        writerNickNameLabel.text = userNickName
        writerProfileImageView.kf.setImage(with: URL(string: userProfileImageURL))
        
        let postWriteTime = postTime.getHowLongAgo()
        postWriteTimeLabel.text = postWriteTime
    }
}

// MARK: - AutoLayout
private extension WriterInfoCollectionViewCell {
    
    func configureUI() {
        configureWriterProfileImageView()
        configureWriterNickNameLabel()
        configurePostWriteTimeLabel()
        configureChattingButton()
    }
    
    func configureWriterProfileImageView() {
        contentView.addSubview(writerProfileImageView)
        
        writerProfileImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(contentView.snp.leading).offset(15)
            $0.width.height.equalTo(50)
        }
    }
    
    func configureWriterNickNameLabel() {
        contentView.addSubview(writerNickNameLabel)
        
        writerNickNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(writerProfileImageView.snp.trailing).offset(15)
            $0.width.equalTo(200)
            $0.height.equalTo(30)
        }
    }
    
    func configurePostWriteTimeLabel() {
        contentView.addSubview(postWriteTimeLabel)
        
        postWriteTimeLabel.snp.makeConstraints {
            $0.top.equalTo(writerNickNameLabel.snp.bottom).offset(5)
            $0.leading.equalTo(writerProfileImageView.snp.trailing).offset(15)
            $0.height.equalTo(20)
        }
    }
    
    func configureChattingButton() {
        contentView.addSubview(chattingButton)
        
        chattingButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(20)
            $0.width.equalTo(80)
            $0.height.equalTo(40)
        }
    }
}
