//
//  CommentTextfieldView.swift
//  FenceApp
//
//  Created by Woojun Lee on 11/10/23.
//

import UIKit
import SnapKit

class CommentInputView: UIView {
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "defaultPerson")
        return iv
    }()
    
    private let label: UILabel = {
       let label = UILabel()
        label.text = "댓글을 남겨보세요"
        label.backgroundColor = .systemGray3
        return label
    }()
    
    private let spacer: UIView = {
       let view = UIView()
        view.backgroundColor = .systemGray
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
        addViews()
        configureImageView()
        configureLabel()
        configureSpacer()
    }
    
    private func addViews() {
        addSubviews(imageView, label, spacer)
    }
    
    private func configureImageView() {
        imageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(10)
            $0.width.height.equalTo(30)
        }
    }
    
    private func configureLabel() {
        label.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).offset(10)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func configureSpacer() {
        spacer.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(0.2)
        }
    }
}
