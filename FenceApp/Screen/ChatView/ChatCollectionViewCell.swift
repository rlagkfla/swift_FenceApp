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
    private let imageLoader: ImageLoader = ImageLoader()
    
    // MARK: - UI Properties
    private let foundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .red
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
    
    func setImage(urlString: String) {
        Task {
            do {
                let image = try await imageLoader.fetchPhoto(urlString: urlString)
                foundImageView.image = image
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: - AutoLayout
    private func configureFoundImageView() {
        contentView.addSubview(foundImageView)
        
        foundImageView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
}
