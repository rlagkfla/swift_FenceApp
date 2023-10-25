//
//  ChatViewController.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/16/23.
//

import UIKit
import Kingfisher

class ChatViewController: UIViewController {
    
    private let chatView = ChatView()
    
    let firebaseFoundService: FirebaseFoundService
    var foundList: [FoundResponseDTO] = []
    
    init(firebaseFoundService: FirebaseFoundService) {
        self.firebaseFoundService = firebaseFoundService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = chatView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurefoundCollectionView()
        getFoundList()
        
        view.backgroundColor = .white
        
        self.navigationItem.title = "FoundList"
    }
    
    private func getFoundList() {
        Task {
            do {
                foundList = try await firebaseFoundService.fetchFounds()
                chatView.foundCollectionView.reloadData()
            } catch {
                print("error")
            }
        }
    }
    
    private func configurefoundCollectionView() {
        chatView.foundCollectionView.dataSource = self
        chatView.foundCollectionView.delegate = self
    }
}

extension ChatViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foundList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = chatView.foundCollectionView.dequeueReusableCell(withReuseIdentifier: ChatCollectionViewCell.identifier, for: indexPath) as! ChatCollectionViewCell
        cell.foundImageView.kf.setImage(with: URL(string: foundList[indexPath.row].imageURL))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: chatView.foundCollectionView.frame.width / 3 - 2, height: chatView.foundCollectionView.frame.width / 3 - 2)
    }
}
