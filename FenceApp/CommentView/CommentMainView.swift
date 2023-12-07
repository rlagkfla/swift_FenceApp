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

final class CommentMainView: UIView {
    
    //MARK: - Properties
    
    weak var delegate: CommentMainViewDelegate?
    
    let collectionViewContainer = UIView()
    
    let writeCommentView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.backgroundColor = .white
        
        return view
    }()
    
    lazy var writeCommentTextView: UITextView = {
        let textView = UITextView()
        textView.text = "댓글을 입력해주세요."
        textView.textColor = .lightGray
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.layer.borderWidth = 1
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.isScrollEnabled = false
        textView.textContainerInset.left = 5
        textView.textContainerInset.right = 45
        textView.autocorrectionType = .no
        textView.autocapitalizationType = .none
        textView.delegate = self
        return textView
    }()

    private lazy var commentSendButton: UIButton = {
        let button = UIButton()
        button.setTitle("작성", for: .normal)
        button.setTitleColor(UIColor(hexCode: "5DDFDE"), for: .normal)
        button.addTarget(self, action: #selector(commendSendButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        configureAction()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func layoutSubviews() {
        writeCommentTextView.layer.cornerRadius = writeCommentTextView.frame.height / 2
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    @objc func keyboardUp(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            
            UIView.animate(
                withDuration: 0.3
                , animations: { [weak self] in
                    guard let self else { return }
                    writeCommentView.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle.height)
                }
            )
        }
    }
    
    @objc func keyboardDown(notification: NSNotification) {
        writeCommentView.transform = .identity
    }
    
    @objc func dismisKeyboard() {
        endEditing(true)
    }
    
    @objc func commendSendButtonTapped() {
        
        guard let comment = writeCommentTextView.text, writeCommentTextView.textColor == .black, writeCommentTextView.text != ""   else { return }
        
        writeCommentTextView.resignFirstResponder()
        writeCommentTextView.text = "댓글을 입력해주세요."
        writeCommentTextView.textColor = .lightGray
        
        delegate?.commentButtonTapped(comment: comment)
    }
    
    //MARK: - Helpers
    
    private func configureAction() {
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismisKeyboard)))
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

//MARK: - UI

extension CommentMainView {
    
    private func configureUI() {
        configureCollectionView()
        configureWriteCommentView()
        configureWriteCommentTextView()
        configureCommentSendButton()
        
    }
    
    private func configureCollectionView() {
        addSubview(collectionViewContainer)
        collectionViewContainer.snp.makeConstraints {
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
    
    private func configureWriteCommentTextView() {
        writeCommentView.addSubview(writeCommentTextView)
        
        writeCommentTextView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.bottom.equalToSuperview().inset(30)
        }
    }
    
    private func configureCommentSendButton() {
        writeCommentView.addSubview(commentSendButton)
        
        commentSendButton.snp.makeConstraints {
            $0.trailing.equalTo(writeCommentTextView.snp.trailing).inset(10)
            $0.bottom.equalTo(writeCommentTextView.snp.bottom).inset(1)
        }
    }
}
