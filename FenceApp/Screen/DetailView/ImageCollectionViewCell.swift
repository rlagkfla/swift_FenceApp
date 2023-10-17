//
//  ImageCollectionViewCell.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/17/23.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    static let identifier: String = "imageCell"
    
    // MARK: - UI Properties
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "코주부 원숭이")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - AutoLayout
private extension ImageCollectionViewCell {
    func configureImageView() {
        self.addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}
