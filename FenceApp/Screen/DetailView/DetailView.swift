//
//  DetailView.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/17/23.
//

import UIKit
import SnapKit

class DetailView: UIView {
    
    // MARK: - UI Properties
    lazy var imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        collectionView.decelerationRate = .fast
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    let pageControl = UIPageControl()

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
        
        configureImageCollectionView()
        configurePageControl()
    }
    
    func configureImageCollectionView() {
        self.addSubview(imageCollectionView)
        
        imageCollectionView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            $0.leading.equalTo(self.safeAreaLayoutGuide.snp.leading)
            $0.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing)
            $0.height.equalTo(300)
        }
    }
    
    func configurePageControl() {
        self.addSubview(pageControl)
        
        pageControl.snp.makeConstraints {
            $0.centerY.equalTo(self.safeAreaLayoutGuide.snp.top).offset(285)
            $0.centerX.equalToSuperview()
        }
    }
}
