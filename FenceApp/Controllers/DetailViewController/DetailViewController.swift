//
//  DetailViewController.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/16/23.
//

import UIKit

final class DetailViewController: UIViewController {
    
    // MARK: - Properties
    private let detailView = DetailView()
    
    let firebaseAuthService: FirebaseAuthService
    let firebaseCommentService: FirebaseLostCommentService
    let firebaseUserService: FirebaseUserService
    
    var pushToCommentVC: ( () -> Void )?
    let lost: Lost
    var comments: [Comment] = []
    
    init(lost: Lost, firebaseCommentService: FirebaseLostCommentService, firebaseUserService: FirebaseUserService, firebaseAuthService: FirebaseAuthService) {
        self.lost = lost
        self.firebaseCommentService = firebaseCommentService
        self.firebaseUserService = firebaseUserService
        self.firebaseAuthService = firebaseAuthService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func loadView() {
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    // MARK: - Action
    @objc func tapped() {
        let commentVC = CommentDetailViewController(firebaseCommentService: firebaseCommentService, lost: lost)
        commentVC.modalTransitionStyle = .coverVertical
        commentVC.modalPresentationStyle = .pageSheet
        commentVC.delegate = self
        
        if let sheet = commentVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        
        present(commentVC, animated: true)
    }
}

// MARK: - Priavte Method
private extension DetailViewController {
    private func configure() {
        view.backgroundColor = .white
        
        self.navigationItem.title = "상세 페이지"
        self.navigationItem.backBarButtonItem?.tintColor = .accent
        self.navigationController?.navigationBar.backgroundColor = .white
        
        configureCollectionView()
        getFirstComment()
    }
    
    private func configureCollectionView() {
        detailView.detailCollectionView.dataSource = self
        detailView.detailCollectionView.delegate = self
    }
    
    private func getFirstComment() {
        Task {
            do {
                let CommentDTOs = try await firebaseCommentService.fetchComments(lostIdentifier: lost.lostIdentifier)
                comments = CommentResponseDTOMapper.makeComments(from: CommentDTOs)
            } catch {
                print(error)
            }
        }
    }
}

//MARK: - Collectionview Delegate

extension DetailViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if indexPath.section == 4 {
//            print("I am five")
//        }
    }
}
// MARK: - UICollectionViewDataSource
extension DetailViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
   
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 1
        } else if section == 2 {
            return 1
        } else if section == 3 {
            return 10
        } else {
            return comments.count == 0 ? 0: min(10, comments.count)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as! ImageCollectionViewCell
            imageCell.getImageUrl(urlString: lost.imageURL)
            return imageCell
        } else if indexPath.section == 1 {
            let writerCell = collectionView.dequeueReusableCell(withReuseIdentifier: WriterInfoCollectionViewCell.identifier, for: indexPath) as! WriterInfoCollectionViewCell
            writerCell.configureCell(userNickName: lost.userNickName, userProfileImageURL: lost.userProfileImageURL, postTime: "\(lost.postDate)")
            return writerCell
        } else if indexPath.section == 2 {
            let postCell = collectionView.dequeueReusableCell(withReuseIdentifier: PostInfoCollectionViewCell.identifier, for: indexPath) as! PostInfoCollectionViewCell
            postCell.configureCell(postTitle: lost.title, postDescription: lost.description, lostTime: lost.lostDate, lost: lost)
            return postCell
        } else if indexPath.section == 3 {
            let commentCell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentCell.identifier, for: indexPath) as! CommentCell
            commentCell.optionImageTapped = { print("Tapped") }

            return commentCell
            
        } else {
            
            let lastNextCell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentNextLastCell.identifier, for: indexPath) as! CommentNextLastCell
            
            return lastNextCell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CommentHeaderView.identifier, for: indexPath) as! CommentHeaderView
            header.commentHeaderViewTapped = { [weak self] in
                self?.pushToCommentVC?()
            }
            return header
            
        } else {
            
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CommentFooterView.identifier, for: indexPath) as! CommentFooterView
            footer.commentFooterViewTapped = { [weak self] in
                self?.pushToCommentVC?()
            }
            return footer
        }
    }
}


// MARK: - CustomDelegate
extension DetailViewController: CommentDetailViewControllerDelegate {
    func dismissCommetnDetailViewController(lastComment: CommentResponseDTO) {
//        lastCommentDTO = lastComment
        self.detailView.detailCollectionView.reloadSections(IndexSet(integer: 3))
    }
}
