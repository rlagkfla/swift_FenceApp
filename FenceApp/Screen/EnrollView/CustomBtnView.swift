//
//  CustomBtnView.swift
//  FenceApp
//
//  Created by t2023-m0067 on 10/19/23.
//

import UIKit
import SnapKit

class CustomBtnView: UIView {

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .cyan
        return view
    }()

    private let cameraImgView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        return imageView
    }()

    private let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CustomBtnView {
    
    private func configureUI(){
        addSubview(containerView)
        containerView.addSubview(cameraImgView)
        containerView.addSubview(label)
        
        containerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        cameraImgView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(containerView.snp.height).dividedBy(2)
        }

        label.snp.makeConstraints {
            $0.top.equalTo(cameraImgView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func setup(image: UIImage, text: String) {
        cameraImgView.image = image
        label.text = text
    }
    
}
