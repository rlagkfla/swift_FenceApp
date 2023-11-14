//
//  CommentFooterView.swift
//  FenceApp
//
//  Created by Woojun Lee on 11/10/23.
//

import UIKit
import SnapKit

class CommentFooterView: UICollectionReusableView {
    
    static let identifier = "CommentFooterView"
    
    private let commentInputView = CommentInputView()
       
    var commentFooterViewTapped: ( () -> Void )?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        addGestureOnSelf()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        
        addSubview(commentInputView)
        commentInputView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @objc private func selfTapped() {
        commentFooterViewTapped?()
    }
    
    private func addGestureOnSelf() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selfTapped)))
        
    }
    
    
    
   
    
    
    

    
    
    
    
}
