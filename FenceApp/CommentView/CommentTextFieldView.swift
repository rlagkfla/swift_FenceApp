//
//  CommentTextFieldView.swift
//  FenceApp
//
//  Created by Woojun Lee on 11/10/23.
//

import UIKit
import SnapKit

class CommentTextFieldView: UIView {
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .gray
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        configureTextView()
    }
    
    private func configureTextView() {
        addSubview(textView)
        textView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(30)
        }
    }
}
