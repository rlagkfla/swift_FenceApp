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
        
        collectionView.register(CommentCell.self, forCellWithReuseIdentifier: CommentCell.identifier)
        collectionView.register(CommentNextLastCell.self, forCellWithReuseIdentifier: CommentNextLastCell.identifier)
        
        collectionView.register(CommentHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CommentHeaderView.identifier)
        collectionView.register(CommentFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CommentFooterView.identifier)
        collectionView.showsVerticalScrollIndicator = true
        return collectionView
    }()
    
//    let reportOptionView = ReportOptionView()
    
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
        configureCollectionView()
//        configureReportOptionView()
    }
    
    func configureCollectionView() {
        self.addSubview(detailCollectionView)
        
        detailCollectionView.snp.makeConstraints {
            $0.edges.equalTo(self.safeAreaLayoutGuide.snp.edges)
        }
    }
    
//    func configureReportOptionView() {
//        addSubviews(reportOptionView)
//        
//        reportOptionView.snp.makeConstraints {
//            $0.edges.equalToSuperview()
//        }
//    }
}
