//
//  ChatView.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/23/23.
//

import UIKit

class ChatView: UIView {
    
    // MARK: - UI Properties
    let foundCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ChatCollectionViewCell.self, forCellWithReuseIdentifier: ChatCollectionViewCell.identifier)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - AutoLayout
private extension ChatView {
    func configureUI() {
        configureFoundCollectionView()
    }
    
    func configureFoundCollectionView() {
        self.addSubview(foundCollectionView)
        
        foundCollectionView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
}
