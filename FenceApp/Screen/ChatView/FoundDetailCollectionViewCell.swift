//
//  FoundDetailCollectionViewCell.swift
//  FenceApp
//
//  Created by t2023-m0067 on 11/13/23.
//

import UIKit
import SnapKit
import Kingfisher

class FoundDetailCollectionViewCell: UICollectionViewCell {
    
    static let identifier: String = "FoundImageCell"
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        imageView.kf.setImage(with: url)
    }
    
//    func clearImage() {
//        imageView.image = nil
//    }
    
    // MARK: - AutoLayout
    private func configure() {
        contentView.addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
    }
    
}
