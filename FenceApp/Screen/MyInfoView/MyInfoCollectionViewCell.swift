//
//  MyInfoCollectionViewCell.swift
//  FenceApp
//
//  Created by t2023-m0063 on 10/31/23.
//

import UIKit
import Kingfisher

class MyInfoCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "MyInfoCollectionViewCell"
    
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
    
    func setImage(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        imageView.kf.setImage(with: url)
    }
}

extension MyInfoCollectionViewCell{
    private func configureUI(){
        self.addSubview(imageView)
    }
}
