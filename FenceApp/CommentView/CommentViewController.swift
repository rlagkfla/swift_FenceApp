//
//  CommentCollectionViewController.swift
//  FenceApp
//
//  Created by Woojun Lee on 11/8/23.
//

import UIKit

protocol CommentViewControllerDelegate: AnyObject {
    func disappearCommentViewController()
}

class CommentViewController: MainViewController<CommentMainView> {
    
    var comments: [Comment] = []
    let firebaseLostCommentService: FirebaseLostCommentService
    let firebaseCloudMessaging: FirebaseCloudMessaging
    let lost: Lost
    let commentTo: CommentTo
    weak var delegate: CommentViewControllerDelegate?
    
    var transitToReportVC: ( () -> Void )?
    
    var isMyComment: Bool = false
    
    lazy var commentCollectionViewController: CommentCollectionVC = {
        let vc = CommentCollectionVC(collectionViewLayout: CommentCompositionalLayout().configureLayout())
        vc.alertMethod = { [weak self] comment in
            guard let self else { return }
            alertControllerAction(comment: comment)
        }
        return vc
    }()
    
    init(firebaseLostCommentService: FirebaseLostCommentService, firebaseCloudMessaging: FirebaseCloudMessaging, lost: Lost, commentTo: CommentTo) {
        self.firebaseLostCommentService = firebaseLostCommentService
        self.firebaseCloudMessaging = firebaseCloudMessaging
        self.lost = lost
        self.commentTo = commentTo
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        print("CommentVC - Deinit")
        commentCollectionViewController.remove()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView.delegate = self
        add(commentCollectionViewController, to: mainView.collectionViewContainer)
        
        Task {
            do {
                try await getComments()
                commentCollectionViewController.makeSnapshot(comments: comments)
                commentCollectionViewController.collectionViewScrollTo(commentTo: commentTo)
                
            } catch {
                print(error)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if commentTo == .write {
            mainView.writeCommentTextView.becomeFirstResponder()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.disappearCommentViewController()
    }
    
    private func alertControllerAction(comment: Comment) {
        
        Task {
            
            do {
                if CurrentUserInfo.shared.isWrittenByCurrentUser(userIdentifier: comment.userIdentifier) {
                    try await self.firebaseLostCommentService.deleteComment(lostIdentifier: comment.lostIdentifier, commentIdentifier: comment.commentIdentifier)
                    try await self.getComments()
                    
                } else {
                    transitToReportVC?()
                }
                
            } catch {
                print(error)
            }
        }
    }
    
    private func createComment(text: String) async throws {
        guard let user = CurrentUserInfo.shared.currentUser else { throw PetError.noUser }
        try await firebaseLostCommentService.createComment(commentResponseDTO: CommentResponseDTO(lostIdentifier: lost.lostIdentifier, userIdentifier: user.identifier, userProfileImageURL: user.profileImageURL, userNickname: user.nickname, commentDescription: text, commentDate: Date()))
    }
    
    
    private func getComments() async throws {
        let commentResponseDTOs = try await firebaseLostCommentService.fetchComments(lostIdentifier: lost.lostIdentifier)
        comments = CommentResponseDTOMapper.makeComments(from: commentResponseDTOs)
        print(comments.count, "$$$$")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Comment MainView Delegate

extension CommentViewController: CommentMainViewDelegate {
    func commentButtonTapped(comment: String) {
        
        let alertController = UIAlertController(title: "댓글 작성 중입니다.", message: "잠시만 기다려주세요.", preferredStyle: .alert)
        self.present(alertController, animated: true)
        
        Task {
            do {
                try await createComment(text: comment)
                try await getComments()
                if lost.userIdentifier != CurrentUserInfo.shared.currentUser?.identifier {
                    try await firebaseCloudMessaging.sendCommentMessaing(userToken: lost.userFCMToken, title: lost.title, comment: comment)
                }
                //                collectionViewScrollTo(commentTo: .last)
                commentCollectionViewController.makeSnapshot(comments: comments)
                
                alertController.dismiss(animated: true)
                
            } catch {
                print(error)
            }
        }
    }
}

