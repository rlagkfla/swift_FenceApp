//
//  ChatViewController.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/16/23.
//

import UIKit
import Kingfisher

class ChatViewController: UIViewController {
    
    // MARK: - Properties
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
    
    // MARK: - Life Cycle
    override func loadView() {
        view = chatView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getFoundList()
    }
    
    func configure() {
        view.backgroundColor = .white
        
        self.navigationItem.title = "FoundList"
        
        configurefoundCollectionView()
        getFoundList()
    }
}

// MARK: - Private Method
private extension ChatViewController {
    func getFoundList() {
        Task {
            do {
                foundList = try await firebaseFoundService.fetchFounds()
                chatView.foundCollectionView.reloadData()
            } catch {
                print("error")
            }
        }
    }
    
    func configurefoundCollectionView() {
        chatView.foundCollectionView.dataSource = self
        chatView.foundCollectionView.delegate = self
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension ChatViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foundList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = chatView.foundCollectionView.dequeueReusableCell(withReuseIdentifier: ChatCollectionViewCell.identifier, for: indexPath) as! ChatCollectionViewCell
        cell.setFoundImageView(foundImageUrl: foundList[indexPath.row].imageURL)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: chatView.foundCollectionView.frame.width / 3 - 2, height: chatView.foundCollectionView.frame.width / 3 - 2)
    }
}
