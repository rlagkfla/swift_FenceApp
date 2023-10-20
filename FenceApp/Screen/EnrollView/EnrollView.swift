//
//  EnrollView.swift
//  FenceApp
//
//  Created by t2023-m0067 on 10/19/23.
//

import UIKit
import SnapKit

class EnrollView: UIView {
  
    private let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.backgroundColor = .clear
        scroll.isDirectionalLockEnabled = true
        scroll.alwaysBounceHorizontal = false
        scroll.alwaysBounceVertical = true
        return scroll
    }()
    
    lazy var customBtnView: CustomBtnView = {
        let view = CustomBtnView()
        view.setup(image: UIImage(systemName: "camera.fill")!, text: "0 / 10")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(customButtonTapped))
        view.addGestureRecognizer(tapGesture)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func customButtonTapped() {
        print("Custom Button Tapped")
        // 원하는 작업을 여기에 추가
    }
    
}

extension EnrollView {
    
    func configureUI(){
        self.addSubview(scrollView)
        scrollView.addSubviews(customBtnView)

        scrollView.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        customBtnView.snp.makeConstraints {
            $0.top.equalTo(scrollView.snp.top).offset(10)
            $0.width.height.equalTo(100)
        }

    }
    
}
