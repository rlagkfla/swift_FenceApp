//
//  MyInfoCollectionViewCell.swift
//  FenceApp
//
//  Created by t2023-m0063 on 10/31/23.
//

import UIKit

class MyInfoCollectionViewCell: UICollectionViewCell {
    static let identifier = "Cell"
    
    let imageView: UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .black
        img.layer.cornerRadius = 7
        img.layer.masksToBounds = true
        img.contentMode = .scaleAspectFill
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

extension MyInfoCollectionViewCell{
    func configureUI(){
        self.addSubview(imageView)
        
        
    }
}
