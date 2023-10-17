//
//  WriterInfoTableViewCell.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/17/23.
//

import UIKit

class WriterInfoTableViewCell: UITableViewCell {
    
    static let identifier: String = "WriterInfoCell"

    let writerProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "코주부 원숭이")
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.clear.cgColor
        
        return imageView
    }()
    
    let writerNickNameLabel: UILabel = {
        let label = UILabel()
        label.text = "코주부 원숭이"
        label.font = UIFont.systemFont(ofSize: 20)
        label.textAlignment = .left
        label.backgroundColor = .red
        return label
    }()
    
    let postWriteTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "\(Calendar.current.dateComponents([.minute], from: Date()))"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .systemGray
        label.textAlignment = .center
        label.backgroundColor = .yellow
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

private extension WriterInfoTableViewCell {
    func configureUI() {
        configureWriterProfileImageView()
        configureWriterNickNameLabel()
        configurePostWriteTimeLabel()
    }
    
    func configureWriterProfileImageView() {
        self.addSubview(writerProfileImageView)
        
        writerProfileImageView.snp.makeConstraints {
            $0.top.equalTo(self.snp.top).offset(10)
            $0.leading.equalTo(self.snp.leading).offset(10)
            $0.width.height.equalTo(50)
        }
    }
    
    func configureWriterNickNameLabel() {
        self.addSubview(writerNickNameLabel)
        
        writerNickNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(writerProfileImageView.snp.centerY)
            $0.leading.equalTo(writerProfileImageView.snp.trailing).offset(10)
            $0.width.equalTo(200)
            $0.height.equalTo(50)
        }
    }
    
    func configurePostWriteTimeLabel() {
        self.addSubview(postWriteTimeLabel)
        
        postWriteTimeLabel.snp.makeConstraints {
            $0.centerY.equalTo(writerProfileImageView.snp.centerY)
            $0.leading.equalTo(writerNickNameLabel.snp.trailing)
            $0.trailing.equalTo(self.snp.trailing).offset(-10)
            $0.height.equalTo(50)
        }
    }
}
