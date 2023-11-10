//
//  DetailViewController.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/16/23.
//

import UIKit

protocol DetailViewControllerDelegate: AnyObject {
    func deleteMenuTapped()
}

final class DetailViewController: UIViewController {
    
    // MARK: - Properties
    private let detailView = DetailView()
    
    weak var delegate: DetailViewControllerDelegate?
    
    let firebaseAuthService: FirebaseAuthService
    let firebaseCommentService: FirebaseLostCommentService
    let firebaseUserService: FirebaseUserService
    let firebaseLostService: FirebaseLostService
    let locationManager: LocationManager
    
    let lostIdentifier: String
    
    var lost: Lost!
    
    var lastCommentDTO: CommentResponseDTO?
    
    var editButtonTapped: ( () -> Void )?
    
    private var menu = UIMenu()
    
    init(firebaseCommentService: FirebaseLostCommentService, firebaseUserService: FirebaseUserService, firebaseAuthService: FirebaseAuthService, firebaseLostService: FirebaseLostService, locationManager: LocationManager, lostIdentifier: String) {
        self.lostIdentifier = lostIdentifier
        self.firebaseCommentService = firebaseCommentService
        self.firebaseUserService = firebaseUserService
        self.firebaseAuthService = firebaseAuthService
        self.firebaseLostService = firebaseLostService
        self.locationManager = locationManager
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
        Task {
            do {
                try await getLost()
                configure()
            } catch {
                print(error)
            }
        }
    }
    
    func getLost() async throws {
        
        let lostResponseDTO = try await firebaseLostService.fetchLost(lostIdentifier: self.lostIdentifier)
        let lost = LostResponseDTOMapper.makeLost(from: lostResponseDTO)
        self.lost = lost
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
        
        configureMenu()
        configureNavigation()
        configureCollectionView()
        getFirstComment()
    }
    
    func configureMenu() {
        let impossibleAlertController = UIAlertController(title: "불가능합니다", message: "본인 게시글이 아니므로 불가능합니다.", preferredStyle: .alert)
        let deleteAlertController = UIAlertController(title: "삭제하기", message: "정말로 삭제하시겠습니까?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let confirmAction = UIAlertAction(title: "삭제하기", style: .default) { [weak self] _ in
            Task {
                do {
                    try await self!.firebaseLostService.deleteLost(lostIdentifier: self!.lost.lostIdentifier)
                    self?.navigationController?.popViewController(animated: true)
                    self?.delegate?.deleteMenuTapped()
                } catch {
                    print(error)
                }
            }
        }
        impossibleAlertController.addAction(cancelAction)
        deleteAlertController.addAction(cancelAction)
        deleteAlertController.addAction(confirmAction)
        
        let editAction = UIAction(title: "수정하기") { [weak self] _ in
            if self?.lost.userIdentifier == CurrentUserInfo.shared.currentUser?.identifier {
                let erollViewController = EnrollViewController(firebaseLostService: self!.firebaseLostService, locationManager: self!.locationManager, lostIdentifier: self?.lostIdentifier)
                erollViewController.isEdited = true
                erollViewController.delegate = self
                Task {
                    do {
                        let image = try await ImageLoader.fetchPhoto(urlString: self!.lost.imageURL)
                        erollViewController.images.append(image)
                        
                        self?.navigationController?.pushViewController(erollViewController, animated: true)
                    } catch {
                        print(error)
                    }
                }
            } else {
                self?.present(impossibleAlertController, animated: true)
            }
        }
        
        let deleteAction = UIAction(title: "삭제하기") { [weak self] _ in
            if self?.lost.userIdentifier == CurrentUserInfo.shared.currentUser?.identifier {
                self!.present(deleteAlertController, animated: true)
            } else {
                self!.present(impossibleAlertController, animated: true)
            }
        }
        
        let reportAction = UIAction(title: "신고하기") { _ in
            let reportViewController = ReportViewController(lost: self.lost)
            self.navigationController?.pushViewController(reportViewController, animated: true)
        }
        
        
        if self.lost.userIdentifier == CurrentUserInfo.shared.currentUser?.identifier  {
            self.menu = UIMenu(title: "메뉴", options: .displayInline, children: [editAction, deleteAction])
        } else {
            self.menu = UIMenu(title: "메뉴", options: .displayInline, children: [reportAction])
        }
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: nil, image: UIImage(systemName: "ellipsis"), target: self, action: nil, menu: menu)
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor(hexCode: "55BCEF")
    }
    
    private func configureNavigation() {
        let appearnace = UINavigationBarAppearance()
        appearnace.backgroundColor = .white
        
        self.navigationItem.title = "상세 페이지"
        self.navigationItem.backBarButtonItem?.tintColor = .accent
        self.navigationController?.navigationBar.backgroundColor = .white
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.standardAppearance = appearnace
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearnace
        self.navigationController?.navigationBar.compactAppearance = appearnace
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
            imageCell.imageCollectionView.reloadData()
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

extension DetailViewController: EnrollViewControllerDelegate {
    func popEnrollViewController() {
        Task {
            do {
                try await getLost()
                detailView.detailCollectionView.reloadData()
            } catch {
                print(error)
            }
        }
    }
}
