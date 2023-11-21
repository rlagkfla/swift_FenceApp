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

class CommentViewController: UIViewController {
    
    let mainView = CommentMainView()
    var comments: [Comment] = []
    let firebaseLostCommentService: FirebaseLostCommentService
    let firebaseCloudMessaging: FirebaseCloudMessaging
    let lost: Lost
    let commentTo: CommentTo
    weak var delegate: CommentViewControllerDelegate?
    
    var transitToReportVC: ( () -> Void )?
    
    var isMyComment: Bool = false
    
    init(firebaseLostCommentService: FirebaseLostCommentService, firebaseCloudMessaging: FirebaseCloudMessaging, lost: Lost, commentTo: CommentTo) {
        self.firebaseLostCommentService = firebaseLostCommentService
        self.firebaseCloudMessaging = firebaseCloudMessaging
        self.lost = lost
        self.commentTo = commentTo
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        print("CommentVC - Deinit")
    }
    
    override func loadView() {
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connectCollectionView()
        Task {
            do {
                try await getComments()
                mainView.collectionView.reloadData()
               
            } catch {
                print(error)
            }
        }

        
    }
    
    private func collectionViewScrollTo(commentTo: CommentTo) {
        if commentTo == .last {
            mainView.collectionView.scrollToItem(at: IndexPath(item: comments.count - 1, section: 0), at: .bottom, animated: true)
        } else if commentTo == .next {
            mainView.collectionView.scrollToItem(at: IndexPath(item: 10, section: 0), at: .top, animated: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if commentTo == .write {
            mainView.writeCommentTextView.becomeFirstResponder()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
        delegate?.disappearCommentViewController()
    }
    

    
    func setText(text: String) async throws {
        guard let user = CurrentUserInfo.shared.currentUser else { throw PetError.noUser }
        try await firebaseLostCommentService.createComment(commentResponseDTO: CommentResponseDTO(lostIdentifier: lost.lostIdentifier, userIdentifier: user.identifier, userProfileImageURL: user.profileImageURL, userNickname: user.nickname, commentDescription: text, commentDate: Date()))
    }
    
    @objc func keyboardUp(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            
            UIView.animate(
                withDuration: 0.3
                , animations: { [weak self] in
                    guard let self else { return }
                    self.mainView.writeCommentView.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle.height)
                }
            )
        }
    }
    
    @objc func keyboardDown(notification: NSNotification) {
        self.mainView.writeCommentView.transform = .identity
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        mainView.writeCommentTextView.resignFirstResponder()
    }
    
   
    
    private func connectCollectionView() {
        mainView.collectionView.dataSource = self
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

//MARK: - Data Source

extension CommentViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CommentHeaderView.identifier, for: indexPath) as! CommentHeaderView
        header.hideIcon(number: comments.count)
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        comments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentCell.identifier, for: indexPath) as! CommentCell
        
        let comment = comments[indexPath.item]
        cell.setLabel(urlString: comment.userProfileImageURL, nickName: comment.userNickname, description: comment.commentDescription, date: comment.commentDate)
        cell.optionImageTapped = { [weak self] in
            guard let self else { return }
            if CurrentUserInfo.shared.isWrittenByCurrentUser(userIdentifier: comment.userIdentifier) {
                
            } else {
                
            }
//            self.isMyComment = comment.userIdentifier == CurrentUserInfo.shared.currentUser?.identifier
            AlertService.makeAlert { [weak self] in
                self?.transitToReportVC?()
            }
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
                            try await self.firebaseLostCommentService.deleteComment(lostIdentifier: self.lost.lostIdentifier, commentIdentifier: comments[indexPath.row].commentIdentifier)
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
            self.isMyComment ? alertController.addAction(deleteAction) : alertController.addAction(reportAction)
            self.present(alertController, animated: true)
        }
        return cell
    }
}

extension CommentViewController: CommentMainViewDelegate {
    func commentButtonTapped(comment: String) {
        
        let alertController = UIAlertController(title: "댓글 작성 중입니다.", message: "잠시만 기다려주세요.", preferredStyle: .alert)
        
        self.present(alertController, animated: true)
        
        Task {
            do {
                guard let user = CurrentUserInfo.shared.currentUser else { throw PetError.noUser }
                try await firebaseLostCommentService.createComment(commentResponseDTO: CommentResponseDTO(lostIdentifier: lost.lostIdentifier, userIdentifier: user.identifier, userProfileImageURL: user.profileImageURL, userNickname: user.nickname, commentDescription: comment, commentDate: Date()))
                try await getComments()
                if lost.userIdentifier != CurrentUserInfo.shared.currentUser?.identifier {
                    try await firebaseCloudMessaging.sendCommentMessaing(userToken: lost.userFCMToken, title: lost.title, comment: comment)
                }
                mainView.collectionView.reloadData()
                collectionViewScrollTo(commentTo: .last)
                alertController.dismiss(animated: true)
                
            } catch {
                print(error)
            }
        }
       
    }
    
    
}

