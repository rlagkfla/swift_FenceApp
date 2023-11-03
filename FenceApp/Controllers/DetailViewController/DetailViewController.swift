//
//  DetailViewController.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/16/23.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - Properties
    private let detailView = DetailView()
    
    let firebaseAuthService: FirebaseAuthService
    let firebaseCommentService: FirebaseLostCommentService
    let firebaseUserService: FirebaseUserService
    
    
    
    let lost: Lost
    var lastCommentDTO: CommentResponseDTO?
    
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
                lastCommentDTO = try await firebaseCommentService.fetchComments(lostIdentifier: lost.lostIdentifier).last
            } catch {
                print(error)
            }
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else if section == 1 {
            return 1
        } else if section == 2 {
            return 1
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let imageCell = detailView.detailCollectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as! ImageCollectionViewCell
            imageCell.getImageUrl(urlString: lost.imageURL)
            return imageCell
        } else if indexPath.section == 1 {
            let writerCell = detailView.detailCollectionView.dequeueReusableCell(withReuseIdentifier: WriterInfoCollectionViewCell.identifier, for: indexPath) as! WriterInfoCollectionViewCell
            writerCell.configureCell(userNickName: lost.userNickName, userProfileImageURL: lost.userProfileImageURL, postTime: "\(lost.postDate)")
            return writerCell
        } else if indexPath.section == 2 {
            let postCell = detailView.detailCollectionView.dequeueReusableCell(withReuseIdentifier: PostInfoCollectionViewCell.identifier, for: indexPath) as! PostInfoCollectionViewCell
            postCell.configureCell(postTitle: lost.title, postDescription: lost.description, lostTime: lost.lostDate, lost: lost)
            return postCell
        } else {
            let commentCell = detailView.detailCollectionView.dequeueReusableCell(withReuseIdentifier: CommentCollectionViewCell.identifier, for: indexPath) as! CommentCollectionViewCell
            commentCell.commentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
            if let lastCommentDescription = lastCommentDTO?.commentDescription, let lastCommentUserImageUrl = lastCommentDTO?.userProfileImageURL {
                let commentCell = detailView.detailCollectionView.dequeueReusableCell(withReuseIdentifier: CommentCollectionViewCell.identifier, for: indexPath) as! CommentCollectionViewCell
                commentCell.configureCell(lastCommetString: lastCommentDescription, userProfileImageUrl: lastCommentUserImageUrl)
                commentCell.commentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
                return commentCell
            }
            return commentCell
        }
    }
}

// MARK: - CustomDelegate
extension DetailViewController: CommentDetailViewControllerDelegate {
    func dismissCommetnDetailViewController(lastComment: CommentResponseDTO) {
        lastCommentDTO = lastComment
        self.detailView.detailCollectionView.reloadSections(IndexSet(integer: 3))
    }
}
