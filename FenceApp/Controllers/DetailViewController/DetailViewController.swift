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
    let firebaseCommentService: FirebaseLostCommentService
    let lostDTO: LostResponseDTO
    var commentDTOFirst: CommentResponseDTO? = nil
    
    init(lostDTO: LostResponseDTO, firebaseCommentService: FirebaseLostCommentService) {
        self.lostDTO = lostDTO
        self.firebaseCommentService = firebaseCommentService
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
        
        getFirstComment()
        
        view.backgroundColor = .white
        
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        detailView.detailCollectionView.dataSource = self
        detailView.detailCollectionView.delegate = self
    
        self.navigationItem.title = "Detail"
    }
    
    func getFirstComment() {
        Task {
            do {
                commentDTOFirst = try await firebaseCommentService.fetchComments(lostIdentifier: lostDTO.lostIdentifier).first
                detailView.detailCollectionView.reloadData()
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: - Action
    @objc func tapped() {
        let commentVC = CommentDetailViewController(firebaseCommentService: firebaseCommentService, lostResponseDTO: lostDTO)
        commentVC.modalTransitionStyle = .coverVertical
        commentVC.modalPresentationStyle = .pageSheet
        
        if let sheet = commentVC.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
        }
        
        present(commentVC, animated: true)
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
            imageCell.getImageUrl(urlString: lostDTO.imageURL)
            return imageCell
        } else if indexPath.section == 1 {
            let writerCell = detailView.detailCollectionView.dequeueReusableCell(withReuseIdentifier: WriterInfoCollectionViewCell.identifier, for: indexPath) as! WriterInfoCollectionViewCell
            writerCell.writerNickNameLabel.text = lostDTO.userNickName
            writerCell.setPostWriteTime(postTime: "\(lostDTO.postDate)")
            writerCell.writerProfileImageView.kf.setImage(with: URL(string: lostDTO.userProfileImageURL))
            return writerCell
        } else if indexPath.section == 2 {
            let postCell = detailView.detailCollectionView.dequeueReusableCell(withReuseIdentifier: PostInfoCollectionViewCell.identifier, for: indexPath) as! PostInfoCollectionViewCell
            postCell.postTitleLabel.text = lostDTO.title
            postCell.postDescriptionLabel.text = lostDTO.description
            postCell.setLabel(lostTime: lostDTO.lostDate)
//            postCell.setMapPinRegion(latitude: lostDTO.latitude, longitude: lostDTO.longitude)
            postCell.setPin(pinable: lostDTO)
            postCell.centerViewOnUserLocation()
            return postCell
        } else {
            let commentCell = detailView.detailCollectionView.dequeueReusableCell(withReuseIdentifier: CommentCollectionViewCell.identifier, for: indexPath) as! CommentCollectionViewCell
            commentCell.commentImageView.kf.setImage(with: URL(string: lostDTO.userProfileImageURL))
            commentCell.commentTextLabel.text = commentDTOFirst?.commentDescription
            commentCell.commentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapped)))
            return commentCell
        }
    }
}

