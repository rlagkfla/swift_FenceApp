//
//  CustomModalViewController.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/27/23.
//

import UIKit
import SnapKit

class CustomModalViewController: UIViewController {
    
    let pinable: Pinable
    
    var transitToDetailVC: ( (Lost) -> Void )?
    
    let petImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .white
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let petNameLabel: UILabel = {
        let label = UILabel()
        label.text = "이름: 전콩"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20)
        label.backgroundColor = .white
        return label
    }()
    
    let postDateLabel: UILabel = {
        let label = UILabel()
        label.text = "날짜"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20)
        label.backgroundColor = .white
        return label
    }()
    
    lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(self.cancelButton)
        stackView.addArrangedSubview(self.presentButton)
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("취소", for: .normal)
        button.setTitleColor(UIColor(hexCode: "55BCEF"), for: .normal)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor(hexCode: "55BCEF").cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var presentButton: UIButton = {
        let button = UIButton()
        button.setTitle("이동", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(hexCode: "55BCEF")
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(presentButtonTapped), for: .touchUpInside)
        return button
    }()
    
    init(pinable: Pinable) {
        self.pinable = pinable
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSelf()
        configureUI()
        configureModal()
    }
    
    private func configureModal() {
        let url = URL(string: pinable.imageURL)
        
        petImageView.kf.setImage(with: url)
        
       if let lost = pinable as? Lost {
            petNameLabel.text = "반려동물 이름 : \(lost.petName)"
            
            
            let postDateFormatter = "잃어버린 날짜 : " + ("\(lost.lostDate)").getHowLongAgo()
            postDateLabel.text = postDateFormatter
        }
    }
    
    func configureModal(petImageUrl: String, petName: String, postDate: String, isLost: Bool) {
        petImageView.kf.setImage(with: URL(string: petImageUrl))
        petNameLabel.text = "이름: \(petName)"
        
        let postDateFormatter = postDate.getHowLongAgo()
        postDateLabel.text = postDateFormatter
    }
    
    private func setSelf() {
        self.modalTransitionStyle = .coverVertical
        self.modalPresentationStyle = .pageSheet
        if let sheet = self.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
    }
}

extension CustomModalViewController {
    @objc func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func presentButtonTapped() {
        print(#function)
        if let lost = pinable as? Lost {
            
            transitToDetailVC?(lost)
        }
        
    }
}

private extension CustomModalViewController {
    func configureUI() {
        view.backgroundColor = .white
        
        configureImageView()
        configurePetNameLabel()
        configurePostDate()
        configureButtonsStackView()
    }
    
    func configureImageView() {
        view.addSubview(petImageView)
        
        petImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(30)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(250)
        }
    }
    
    func configurePetNameLabel() {
        view.addSubview(petNameLabel)
        
        petNameLabel.snp.makeConstraints {
            $0.top.equalTo(petImageView.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
    }
    
    func configurePostDate() {
        view.addSubview(postDateLabel)
        
        postDateLabel.snp.makeConstraints {
            $0.top.equalTo(petNameLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
    }
    
    func configureButtonsStackView() {
        view.addSubview(buttonsStackView)
        
        buttonsStackView.snp.makeConstraints {
            $0.top.equalTo(postDateLabel.snp.bottom).offset(15)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.height.equalTo(35)
        }
    }
}
