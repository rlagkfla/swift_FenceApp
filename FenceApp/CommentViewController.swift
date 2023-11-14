//
//  CommentCollectionViewController.swift
//  FenceApp
//
//  Created by Woojun Lee on 11/8/23.
//

import UIKit

class CommentViewController: UIViewController {
    
    let mainView = CommentMainView()
    var comments: [Comment] = []
    let firebaseLostCommentService: FirebaseLostCommentService
    let firebaseCloudMessaging: FirebaseCloudMessaging
    let lost: Lost
    
    var isMyComment: Bool = false
    
    init(firebaseLostCommentService: FirebaseLostCommentService, firebaseCloudMessaging: FirebaseCloudMessaging, lost: Lost) {
        self.firebaseLostCommentService = firebaseLostCommentService
        self.firebaseCloudMessaging = firebaseCloudMessaging
        self.lost = lost
        super.init(nibName: nil, bundle: nil)
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
        configureAction()
        configureWriteCommentView()
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
        
    }
    
    func configureAction() {
        mainView.commentSendButton.addTarget(self, action: #selector(commendSendButtonTapped), for: .touchUpInside)
        mainView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
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
                , animations: {
                    self.mainView.writeCommentView.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle.height)
                }
            )
        }
    }
    
    @objc func keyboardDown(notification: NSNotification) {
        self.mainView.writeCommentView.transform = .identity
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func commendSendButtonTapped() {
        print(#function)
        let commentTextView = mainView.writeCommentTextView
        guard let comment = commentTextView.text else { return }
        guard commentTextView.textColor == .black else { return }
        guard commentTextView.text != "" else { return }
        
        Task {
            do {
                try await setText(text: comment)
                try await getComments()
                try await firebaseCloudMessaging.sendCommentMessaing(userToken: lost.userFCMToken, title: lost.title, comment: comment)
                mainView.writeCommentTextView.text = ""
                mainView.collectionView.reloadData()
            } catch {
                print(error)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        mainView.writeCommentTextView.resignFirstResponder()
    }
    
    private func configureWriteCommentView() {
        mainView.writeCommentTextView.delegate = self
        mainView.writeCommentTextView.autocorrectionType = .no
        mainView.writeCommentTextView.autocapitalizationType = .none
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
        cell.optionImageTapped = {
            self.isMyComment = comment.userIdentifier == CurrentUserInfo.shared.currentUser?.identifier
            
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let cancelAction = UIAlertAction(title: "취소", style: .cancel)
            let reportAction = UIAlertAction(title: "신고하기", style: .destructive) { _ in
                let reportViewController = ReportViewController(comment: comment)
                reportViewController.isLost = false
                self.navigationController?.pushViewController(reportViewController, animated: true)
            }
            let deleteAction = UIAlertAction(title: "삭제하기", style: .destructive) { _ in
                let deleteAlertController = UIAlertController(title: "삭제하기", message: "정말로 삭제하시겠습니까?", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "취소", style: .cancel)
                let deleteAction = UIAlertAction(title: "삭제하기", style: .destructive) { [weak self] _ in
                    Task {
                        do {
                            try await self?.firebaseLostCommentService.deleteComment(lostIdentifier: self!.lost.lostIdentifier, commentIdentifier: self!.comments[indexPath.row].commentIdentifier)
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

extension CommentViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if mainView.writeCommentTextView.text == "댓글을 입력해주세요." {
            mainView.writeCommentTextView.text = ""
            mainView.writeCommentTextView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if mainView.writeCommentTextView.text.isEmpty {
            mainView.writeCommentTextView.text = "댓글을 입력해주세요."
            mainView.writeCommentTextView.textColor = .lightGray
        }
    }
}
