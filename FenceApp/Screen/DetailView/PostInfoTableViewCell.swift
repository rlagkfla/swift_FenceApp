//
//  PostInfoTableViewCell.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/17/23.
//

import UIKit

class PostInfoTableViewCell: UITableViewCell {
    
    static let identifier: String = "PostInfoCell"

    let postTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "강아지 찾아주세요"
        label.font = UIFont.systemFont(ofSize: 24)
        label.textAlignment = .left
        label.backgroundColor = .red
        return label
    }()
    
    let lostTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "잃어버린 시간: \(Date())"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.backgroundColor = .yellow
        return label
    }()
    
    let postDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "강아지 잃어버렸어용ㅠㅠ강아지 잃어버렸어용ㅠㅠ강아지 잃어버렸어용ㅠㅠ강아지 잃어버렸어용ㅠㅠ강아지 잃어버렸어용ㅠㅠ강아지 잃어버렸어용ㅠㅠ강아지 잃어버렸어용ㅠㅠ강아지 잃어버렸어용ㅠㅠ강아지 잃어버렸어용ㅠㅠ강아지 잃어버렸어용ㅠㅠ강아지 잃어버렸어용ㅠㅠ"
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18)
        label.backgroundColor = .red
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        configureUI()
    }

}


private extension PostInfoTableViewCell {
    func configureUI() {
        configurePostTitleLabel()
        configureLostTimeLabel()
        configurePostDescriptionLabel()
    }
    
    func configurePostTitleLabel() {
        self.addSubview(postTitleLabel)
        
        postTitleLabel.snp.makeConstraints {
            $0.top.equalTo(self.snp.top).offset(5)
            $0.leading.equalTo(self.snp.leading).offset(10)
            $0.trailing.equalTo(self.snp.trailing).offset(-10)
            $0.height.equalTo(30)
        }
    }
    
    func configureLostTimeLabel() {
        self.addSubview(lostTimeLabel)
        
        lostTimeLabel.snp.makeConstraints {
            $0.top.equalTo(postTitleLabel.snp.bottom).offset(5)
            $0.leading.equalTo(self.snp.leading).offset(10)
            $0.trailing.equalTo(self.snp.trailing).offset(-10)
            $0.height.equalTo(30)
        }
    }
    
    func configurePostDescriptionLabel() {
        self.addSubview(postDescriptionLabel)
        
        postDescriptionLabel.snp.makeConstraints {
            $0.top.equalTo(lostTimeLabel.snp.bottom).offset(5)
            $0.leading.equalTo(self.snp.leading).offset(10)
            $0.trailing.equalTo(self.snp.trailing).offset(-10)
//            $0.height.equalTo(100)
        }
    }
}
