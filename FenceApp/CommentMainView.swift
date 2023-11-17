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
    
    let writeCommentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let writeCommentTextView: UITextView = {
        let textView = UITextView()
        textView.text = "댓글을 입력해주세요."
        textView.textColor = .lightGray
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.cornerRadius = 20
        textView.layer.borderWidth = 0.5
        textView.layer.borderColor = UIColor.black.cgColor
        textView.isScrollEnabled = false
        textView.textContainerInset.left = 5
        textView.textContainerInset.right = 45
        return textView
    }()
    
    let commentSendButton: UIButton = {
        let button = UIButton()
        button.setTitle("작성", for: .normal)
        button.setTitleColor(UIColor(hexCode: "5DDFDE"), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    override func layoutSubviews() {
        writeCommentView.layer.addBorder(edge: .top, color: .black, thickness: 0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        configureCollectionView()
        configureWriteCommentView()
       
        
    }
    
    private func configureCollectionView() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview().inset(75)
        }
    }
    
    private func configureWriteCommentView() {
        addSubview(writeCommentView)
        
        writeCommentView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.lessThanOrEqualToSuperview()
            $0.height.greaterThanOrEqualTo(50)
        }
        
        configureWriteCommentTextView()
        configureCommentSendButton()
    }
    
    func configureWriteCommentTextView() {
        writeCommentView.addSubview(writeCommentTextView)
        
        writeCommentTextView.snp.makeConstraints {
            $0.top.greaterThanOrEqualToSuperview().offset(10)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.bottom.equalToSuperview().inset(30)
        }
    }
    
    func configureCommentSendButton() {
        writeCommentView.addSubview(commentSendButton)
        
        commentSendButton.snp.makeConstraints {
            $0.trailing.equalTo(writeCommentTextView.snp.trailing).inset(10)
            $0.bottom.equalTo(writeCommentTextView.snp.bottom).inset(1)
        }
    }
}
