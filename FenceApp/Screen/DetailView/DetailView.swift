//
//  DetailView.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/17/23.
//

import UIKit
import SnapKit
import MapKit

class DetailView: UIView {
    
    // MARK: - UI Properties
    lazy var detailCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: DetailViewCompositionalLayout().configureLayout())
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        collectionView.register(WriterInfoCollectionViewCell.self, forCellWithReuseIdentifier: WriterInfoCollectionViewCell.identifier)
        collectionView.register(PostInfoCollectionViewCell.self, forCellWithReuseIdentifier: PostInfoCollectionViewCell.identifier)
        collectionView.register(CommentCollectionViewCell.self, forCellWithReuseIdentifier: CommentCollectionViewCell.identifier)
        collectionView.showsVerticalScrollIndicator = true
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
private extension DetailView {
    func configureUI() {
        self.addSubview(detailCollectionView)
        
        detailCollectionView.snp.makeConstraints {
            $0.edges.equalTo(self.safeAreaLayoutGuide.snp.edges).inset(5)
        }
    }
}
