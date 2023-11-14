//
//  CommentView.swift
//  FenceApp
//
//  Created by Woojun Lee on 11/10/23.
//

import UIKit
import SnapKit

class CommentMainView: UIView {
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: CommentCompositionalLayout().configureLayout())
        
        cv.register(CommentCell.self, forCellWithReuseIdentifier: CommentCell.identifier)
        cv.register(CommentHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CommentHeaderView.identifier)
        return cv
    }()
    
    let commentTextFieldView: CommentTextFieldView = {
        let view = CommentTextFieldView()
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        configureCollectionView()
        configureCommentTextFieldView()
        
    }
    
    private func configureCommentTextFieldView() {
        addSubview(commentTextFieldView)
        
        commentTextFieldView.snp.makeConstraints {
            $0.bottom.leading.trailing.equalToSuperview()
            $0.height.equalTo(100)
        }
    }
    
    private func configureCollectionView() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
