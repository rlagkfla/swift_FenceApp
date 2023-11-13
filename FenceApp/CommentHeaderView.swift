//
//  CommentHeaderView.swift
//  FenceApp
//
//  Created by Woojun Lee on 11/9/23.
//

import UIKit
import SnapKit

class CommentHeaderView: UICollectionReusableView {
    
    static let identifier = "CommentHeaderView"
    
    let label: UILabel = {
        let label = UILabel()
        label.text = "댓글 1 〉"
        return label
    }()
    
    var commentHeaderViewTapped: ( () -> Void )?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        addGestureOnSelf()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        addSubview(label)
        label.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(15)
            
        }
    }
    
    @objc func selfTapped() {
        commentHeaderViewTapped?()
    }
    
    private func addGestureOnSelf() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selfTapped)))
    }
    
    func hideIcon(number: Int) {
        label.text = "댓글 \(number)"
    }
}
