//
//  FoundModalMainView.swift
//  FenceApp
//
//  Created by Woojun Lee on 11/5/23.
//

import UIKit
import SnapKit
import Kingfisher

class FoundModalMainView: UIView {
    
    //MARK: - Properties
    
    let petImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let postDateLabel: UILabel = {
        let label = UILabel()
        label.text = "날짜"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20)
        label.backgroundColor = .white
        return label
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    //MARK: - Helpers
    
    
    
    //MARK: - UI
    
   
    
    private func configureUI() {
        backgroundColor = .white
        configureImageView()
        configurePostDate()
    }
    
    private func configureImageView() {
        addSubview(petImageView)
        
        petImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(250)
        }
    }
    
    private func configurePostDate() {
        addSubview(postDateLabel)
        
        postDateLabel.snp.makeConstraints {
            $0.top.equalTo(petImageView.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
    }
    
    func configureModal(urlString: String, date: Date) {
        
        postDateLabel.text = "업로드 날짜: \(date.dateToString())" 
        guard let url = URL(string: urlString) else { return }
        petImageView.kf.setImage(with: url)
    }
    
    
    
    

    
  
    
    
}
