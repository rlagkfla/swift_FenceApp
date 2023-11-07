//
//  ChatCollectionViewCell.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/23/23.
//

import UIKit

class ChatCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let identifier: String = "ChatCell"
    
    // MARK: - UI Properties
    private let foundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureFoundImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setFoundImageView(foundImageUrl: String) {
        foundImageView.kf.setImage(with: URL(string: foundImageUrl))
    }
    
    // MARK: - AutoLayout
    private func configureFoundImageView() {
        contentView.addSubview(foundImageView)
        
        foundImageView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}
