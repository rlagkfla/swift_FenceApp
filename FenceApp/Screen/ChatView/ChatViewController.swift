//
//  ChatViewController.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/16/23.
//

import UIKit

class ChatViewController: UIViewController {
    
    private let chatView = ChatView()
    
    override func loadView() {
        view = chatView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurefoundCollectionView()
        
        view.backgroundColor = .white
        
        self.title = "FoundList"
    }
    
    private func configurefoundCollectionView() {
        chatView.foundCollectionView.dataSource = self
        chatView.foundCollectionView.delegate = self
    }
}

extension ChatViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = chatView.foundCollectionView.dequeueReusableCell(withReuseIdentifier: ChatCollectionViewCell.identifier, for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: chatView.foundCollectionView.frame.width / 3 - 2, height: chatView.foundCollectionView.frame.width / 3 - 2)
    }
}
