//
//  ChatView.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/23/23.
//

import UIKit

protocol ChatViewDelegate: AnyObject {
    func filterButtonTapped()
}

class ChatView: UIView {
    
    // MARK: - Properties
    weak var delegate: ChatViewDelegate?
    
    // MARK: - UI Properties
    let foundCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 2
        layout.minimumInteritemSpacing = 2
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(ChatCollectionViewCell.self, forCellWithReuseIdentifier: ChatCollectionViewCell.identifier)
        collectionView.backgroundColor = .white
        return collectionView
    }()
    
    private lazy var filterImageView: UIImageView = {
        let iv = UIImageView()
        
        let image = UIImage(systemName: "line.3.horizontal.decrease.circle.fill", withConfiguration:UIImage.SymbolConfiguration(weight: .medium))?
            .applyingSymbolConfiguration(UIImage.SymbolConfiguration(paletteColors:[.white, .systemGray2]))
        iv.image = image
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(filterImageViewTapped)))
        
        return iv
    }()
    
    let filterLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.text = "전체 리스트"
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    // MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func filterImageViewTapped() {
        delegate?.filterButtonTapped()
    }
}

// MARK: - AutoLayout
private extension ChatView {
    func configureUI() {
        configureFilterLabel()
        configureFoundCollectionView()
        configureFilterButton()
    }
    
    func configureFilterLabel() {
        self.addSubview(filterLabel)
        
        filterLabel.snp.makeConstraints {
            $0.top.equalTo(self.safeAreaLayoutGuide).offset(5)
            $0.leading.trailing.equalToSuperview().inset(10)
        }
    }
    
    func configureFoundCollectionView() {
        self.addSubview(foundCollectionView)
        
        foundCollectionView.snp.makeConstraints {
            $0.top.equalTo(filterLabel.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
        }
    }
    
    func configureFilterButton() {
        self.addSubview(filterImageView)
        filterImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(30)
            make.width.height.equalTo(60)
        }
    }
}
