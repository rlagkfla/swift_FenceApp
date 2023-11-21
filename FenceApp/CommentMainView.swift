//
//  CommentView.swift
//  FenceApp
//
//  Created by Woojun Lee on 11/10/23.
//

import UIKit
import SnapKit

protocol CommentMainViewDelegate: AnyObject {
    func commentButtonTapped(comment: String)
}

class CommentMainView: UIView {
    
    weak var delegate: CommentMainViewDelegate?
    
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
    
    lazy var writeCommentTextView: UITextView = {
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
        textView.autocorrectionType = .no
        textView.autocapitalizationType = .none
        textView.delegate = self
        return textView
    }()
    
    lazy var commentSendButton: UIButton = {
        let button = UIButton()
        button.setTitle("작성", for: .normal)
        button.setTitleColor(UIColor(hexCode: "5DDFDE"), for: .normal)
        button.addTarget(self, action: #selector(commendSendButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureAction()
    }
    
    override func layoutSubviews() {
        writeCommentView.layer.addBorder(edge: .top, color: .black, thickness: 0.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func dismissKeyboard() {
        endEditing(true)
    }
    
    @objc func commendSendButtonTapped() {
        print("tapped")
        guard let comment = writeCommentTextView.text else { return }
        guard writeCommentTextView.textColor == .black else { return }
        guard writeCommentTextView.text != "" else { return }
        
        writeCommentTextView.resignFirstResponder()
        writeCommentTextView.text = "댓글을 입력해주세요."
        writeCommentTextView.textColor = .lightGray
        
        delegate?.commentButtonTapped(comment: comment)
    }
    
    func configureAction() {
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }

    
    private func configureUI() {
        configureCollectionView()
        configureWriteCommentView()
        configureWriteCommentTextView()
        configureCommentSendButton()
        
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

extension CommentMainView: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if writeCommentTextView.text == "댓글을 입력해주세요." {
            writeCommentTextView.text = ""
            writeCommentTextView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if writeCommentTextView.text.isEmpty {
            writeCommentTextView.text = "댓글을 입력해주세요."
            writeCommentTextView.textColor = .lightGray
        }
    }
}
