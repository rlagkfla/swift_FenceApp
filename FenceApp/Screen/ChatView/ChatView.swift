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
    
    lazy var filterButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "line.3.horizontal.decrease.circle.fill"), for: .normal)
        button.tintColor = UIColor(hexCode: "5DDFED")
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let filterLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.text = "거리 - 반경 20km 내 / 시간 - 1일 이내 / 동물 - 전체"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
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
