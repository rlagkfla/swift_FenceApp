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
    
    let firebaseCommentService: FirebaseLostCommentService
    let firebaseLostService: FirebaseLostService
    let locationManager: LocationManager
    
    var pushToCommentVC: ( (Lost) -> Void )?
    
    var lost: Lost!
    var comments: [Comment] = []
    let lostIdentifier: String
    
    var editButtonTapped: ( () -> Void )?
    
    var isYourComment = false
    
    let refreshControl = UIRefreshControl()
    
    private var menu = UIMenu()
    
    init(firebaseCommentService: FirebaseLostCommentService, firebaseLostService: FirebaseLostService, locationManager: LocationManager, lostIdentifier: String) {
        self.lostIdentifier = lostIdentifier
        self.firebaseCommentService = firebaseCommentService
        self.firebaseLostService = firebaseLostService
        self.locationManager = locationManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("DetailViewController - Deinit")
    }
    
    // MARK: - Life Cycle
    override func loadView() {
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        Task {
            do {
                try await getLost()
                try await getComment()
                configure()
                detailView.detailCollectionView.reloadData()
            } catch {
                print(error)
            }
        }
    }
    
    // MARK: - Action
    @objc func refreshControlActive() {
        lost = nil
        Task {
            do {
                try await getLost()
                try await getComment()
                self.refreshControl.endRefreshing()
                detailView.detailCollectionView.reloadData()
            } catch {
                print(error)
            }
        }
    }
}

// MARK: - Priavte Method
private extension DetailViewController {
    func getLost() async throws {
        
        let lostResponseDTO = try await firebaseLostService.fetchLost(lostIdentifier: self.lostIdentifier)
        let lost = LostResponseDTOMapper.makeLost(from: lostResponseDTO)
        self.lost = lost
    }
    
    func configure() {
        configureMenu()
        configureNavigation()
        configureCollectionView()
        
        detailView.detailCollectionView.refreshControl = self.refreshControl
        refreshControl.addTarget(self, action: #selector(refreshControlActive), for: .valueChanged)
    }
    
    
    func configureMenu() {
        let impossibleAlertController = UIAlertController(title: "불가능합니다", message: "본인 게시글이 아니므로 불가능합니다.", preferredStyle: .alert)
        let deleteAlertController = UIAlertController(title: "삭제하기", message: "정말로 삭제하시겠습니까?", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        let confirmAction = UIAlertAction(title: "삭제하기", style: .default) { [weak self] _ in
            guard let self else { return }
            Task {
                do {
                    try await self.firebaseLostService.deleteLost(lostIdentifier: self.lost.lostIdentifier)
                    self.navigationController?.popViewController(animated: true)
                    self.delegate?.deleteMenuTapped()
                } catch {
                    print(error)
                }
            }
        }
        impossibleAlertController.addAction(cancelAction)
        deleteAlertController.addAction(cancelAction)
        deleteAlertController.addAction(confirmAction)
        
        let editAction = UIAction(title: "수정하기") { [weak self] _ in
            guard let self else { return }
            if self.lost.userIdentifier == CurrentUserInfo.shared.currentUser?.identifier {
                let erollViewController = EnrollViewController(firebaseLostService: self.firebaseLostService, locationManager: self.locationManager, lostIdentifier: self.lostIdentifier)
                erollViewController.isEdited = true
                erollViewController.delegate = self
                Task {
                    do {
                        let image = try await ImageLoader.fetchPhoto(urlString: self.lost.imageURL)
                        erollViewController.images.append(image)
                        
                        self.navigationController?.pushViewController(erollViewController, animated: true)
                    } catch {
                        print(error)
                    }
                }
            } else {
                self.present(impossibleAlertController, animated: true)
            }
        }
        
        let deleteAction = UIAction(title: "삭제하기") { [weak self] _ in
            guard let self else { return }
            if self.lost.userIdentifier == CurrentUserInfo.shared.currentUser?.identifier {
                self.present(deleteAlertController, animated: true)
            } else {
                self.present(impossibleAlertController, animated: true)
            }
        }
        
        let reportAction = UIAction(title: "신고하기") { [weak self] _ in
            guard let self else { return }
            let reportViewController = ReportViewController(lost: self.lost, postKind: PostKind.lost)
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
    
    func configureNavigation() {
        let naviAppearance = UINavigationBarAppearance()
        naviAppearance.backgroundColor = .white
        
        self.navigationItem.title = "상세 페이지"
        self.navigationItem.backBarButtonItem?.tintColor = .accent
        self.navigationController?.navigationBar.backgroundColor = .white
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.standardAppearance = naviAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = naviAppearance
        self.navigationController?.navigationBar.compactAppearance = naviAppearance
    }
    
    func configureCollectionView() {
        detailView.detailCollectionView.dataSource = self
        detailView.detailCollectionView.delegate = self
    }
    
    func getComment() async throws {
        
        
        let CommentDTOs = try await firebaseCommentService.fetchComments(lostIdentifier: lost.lostIdentifier)
        comments = CommentResponseDTOMapper.makeComments(from: CommentDTOs)
        
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
            return comments.count == 0 ? 0 : min(10, comments.count)
        }
//        } else {
//            return comments.count == 0 ? 0 : 1
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as! ImageCollectionViewCell
            imageCell.getImageUrl(urlString: lost.imageURL)
            imageCell.imageCollectionView.reloadData()
            return imageCell
        } else if indexPath.section == 1 {
            let writerCell = collectionView.dequeueReusableCell(withReuseIdentifier: WriterInfoCollectionViewCell.identifier, for: indexPath) as! WriterInfoCollectionViewCell
            writerCell.configureCell(userNickName: lost.userNickName, userProfileImageURL: lost.userProfileImageURL, postTime: "\(lost.postDate)")
            return writerCell
        } else if indexPath.section == 2 {
            let postCell = collectionView.dequeueReusableCell(withReuseIdentifier: PostInfoCollectionViewCell.identifier, for: indexPath) as! PostInfoCollectionViewCell
            postCell.configureCell(postTitle: lost.title, postDescription: lost.description, lostTime: lost.lostDate, lost: lost)
            return postCell
        } else {
            let commentCell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentCell.identifier, for: indexPath) as! CommentCell
            let comment = comments[indexPath.item]
            commentCell.setLabel(urlString: comment.userProfileImageURL, nickName: comment.userNickname, description: comment.commentDescription, date: comment.commentDate)
            commentCell.optionImageTapped = { [weak self] in
                guard let self else { return }
                self.isYourComment = comment.userIdentifier == CurrentUserInfo.shared.currentUser?.identifier
                
                let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                let cancelAction = UIAlertAction(title: "취소", style: .cancel)
                let reportAction = UIAlertAction(title: "신고하기", style: .destructive) { _ in
                    let reportViewController = ReportViewController(comment: comment, postKind: PostKind.comment)
                    self.navigationController?.pushViewController(reportViewController, animated: true)
                }
                let deleteAction = UIAlertAction(title: "삭제하기", style: .destructive) { _ in
                    let deleteAlertController = UIAlertController(title: "삭제하기", message: "정말로 삭제하시겠습니까?", preferredStyle: .alert)
                    let cancelAction = UIAlertAction(title: "취소", style: .cancel)
                    let deleteAction = UIAlertAction(title: "삭제하기", style: .destructive) { _ in
                        Task {
                            do {
                                let comments = self.comments
                                try await self.firebaseCommentService.deleteComment(lostIdentifier: self.lostIdentifier, commentIdentifier: comments[indexPath.row].commentIdentifier)
                            } catch {
                                print(error)
                            }
                        }
                    }
                    deleteAlertController.addAction(cancelAction)
                    deleteAlertController.addAction(deleteAction)
                    self.present(deleteAlertController, animated: true)
                }
                alertController.addAction(cancelAction)
                self.isYourComment ? alertController.addAction(deleteAction) : alertController.addAction(reportAction)
                self.present(alertController, animated: true)
            }
            
            return commentCell
            
            //        } else {
            //            let lastNextCell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentNextLastCell.identifier, for: indexPath) as! CommentNextLastCell
            //            lastNextCell.nextCommentLabelTapped = {
            //                self.pushToCommentVC?(self.lost)
            //            }
            //
            //            return lastNextCell
            //        }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CommentHeaderView.identifier, for: indexPath) as! CommentHeaderView
            header.setText(number: comments.count)
            header.commentHeaderViewTapped = { [weak self] in
                guard let self else { return }
                self.pushToCommentVC?(self.lost)
            }
            return header
            
        } else {
            
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CommentFooterView.identifier, for: indexPath) as! CommentFooterView
            footer.commentFooterViewTapped = { [weak self] in
                guard let self else { return }
                self.pushToCommentVC?(self.lost)
            }
            return footer
        }
    }
}


// MARK: - CustomDelegate
extension DetailViewController: CommentViewControllerDelegate {
    func disappearCommentViewController() {
        Task {
            do {
                try await getComment()
                detailView.detailCollectionView.reloadSections(IndexSet(integer: 3))
            } catch {
                print(error)
            }
        }
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
