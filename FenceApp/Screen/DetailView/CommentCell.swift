//
//  LostDetailCommentCell.swift
//  FenceApp
//
//  Created by Woojun Lee on 11/8/23.
//

import UIKit
import SnapKit
import Kingfisher

class CommentCell: UICollectionViewCell {
    
    static let identifier = "CommentCell"
    
    var optionImageTapped: ( () -> Void )?
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "defaultPerson")
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 15
        return iv
    }()
    
    private let nickNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.text = "자진12"
        return label
    }()
    
    lazy var optionButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(optionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var optionImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "ellipsis")
        
        return iv
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        
        return stackView
    }()
    
    @objc func optionButtonTapped() {
        optionImageTapped?()
    }
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.text = "암표 사기 많습니다 암표 사기 많습니다 암표 사기 많습니다 암표 사기 많습니다 암표 사기 많습니다 암표 사기 많습니다 암표 사기 많습니다 암표 사기 많습니다 암표 사기 많습니다 암표 사기 많습니다 암표 사기 많습니다 암표 사기 많습니다 암표 사기 많습니다 암표 사기 많습니다 암표 사기 많습니다 암표 사기 많습니다 암표 사기 많습니다 암표 사기 많습니다 암표 사기 많습니다 암표 사기 많습니다 암표 사기 많습니다 암표 사기 많습니다 암표 사기 많습니다 암표 사기 많습니다 암표 사기 많습니다 암표 사기 많습니다 암표 사기 많습니다 암표 사기 많습니다 암표 사기 많습니다 암표 사기 많습니다 암표 사기 많습니다 암표 사기 많습니다 암표 사기 많습니다 암표 사기 많습니다 암표 사기 많습니다 암표 사기 많습니다 암표 사기 많습니다 암표 사기 많습니다"
        label.numberOfLines = 0
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .systemGray2
        label.text = "2023.11.08. 12:52"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLabel(urlString: String, nickName: String, description: String, date: Date) {
        nickNameLabel.text = nickName
        descriptionLabel.text = description
        dateLabel.text = date.formatted()
        let url = URL(string: urlString)
        profileImageView.kf.setImage(with: url)
    }
    
    private func configureUI() {
        configureProfileImageView()
        configureNicknameLabel()
        configureOptionImageView()
        configureContainerView()
        configureDateLabel()
        configureStackView()
    }
    
    private func configureProfileImageView() {
        contentView.addSubview(profileImageView)
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(10)
            $0.leading.equalToSuperview().inset(10)
            $0.width.height.equalTo(30)
        }
    }
    
    private func configureNicknameLabel() {
        contentView.addSubview(nickNameLabel)
        nickNameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(10)
            $0.centerY.equalTo(profileImageView)
            $0.height.equalTo(20)
        }
    }
    
   
    private func configureOptionImageView() {
        contentView.addSubview(optionImageView)
        optionImageView.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView)
            $0.trailing.equalToSuperview().inset(20)
            $0.width.height.equalTo(20)
        }
    }
    
    private func configureContainerView() {
        contentView.addSubview(optionButton)

        optionButton.snp.makeConstraints {
            $0.centerY.centerX.equalTo(optionImageView)
            $0.width.height.equalTo(60)
            
        }
    }
    
    private func configureDateLabel() {
        contentView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.leading.equalTo(nickNameLabel.snp.leading)
            $0.height.equalTo(20)
        }
    }
    
    private func configureStackView() {
        contentView.addSubviews(stackView)
        stackView.addArrangedSubview(descriptionLabel)
        stackView.snp.makeConstraints {
            $0.top.equalTo(nickNameLabel.snp.bottom)
            $0.leading.equalTo(nickNameLabel)
            $0.trailing.equalToSuperview().inset(25)
            $0.bottom.equalTo(dateLabel.snp.top)
        }
    }
    
   
}

