//
//  PhotoCollectionViewCell.swift
//  FenceApp
//
//  Created by t2023-m0067 on 10/22/23.
//

import UIKit
import SnapKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "cell"
    
    let imageView: UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PhotoCollectionViewCell {
    func configureUI(){
        self.addSubview(imageView)
        
        imageView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}

