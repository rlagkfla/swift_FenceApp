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
        img.layer.cornerRadius = 7
        img.layer.masksToBounds = true
        return img
    }()
    
//    let deleteButton: UIButton = {
//        let btn = UIButton()
//        btn.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
//        return btn
//    }()
    
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
//        self.addSubview(deleteButton)
//        self.bringSubviewToFront(deleteButton)
        
        imageView.snp.makeConstraints {
            $0.top.leading.equalToSuperview().offset(7)
            $0.trailing.bottom.equalToSuperview().offset(-7)
        }
//        deleteButton.snp.makeConstraints {
//            $0.trailing.equalToSuperview().offset(-1)
//            $0.top.equalToSuperview().offset(1)
//        }
    }
}

