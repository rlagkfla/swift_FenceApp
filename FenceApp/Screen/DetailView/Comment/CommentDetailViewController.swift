//
//  CommentViewController.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/19/23.
//

import UIKit
import SnapKit

protocol CommentDetailViewControllerDelegate: AnyObject {
    func dismissCommetnDetailViewController(lastComment: CommentResponseDTO)
}

class CommentDetailViewController: UIViewController {
    
    // MARK: - Properties
    private let commentDetailView = CommentDetailView()
    
    let lost: Lost
    
    let firebaseCommentService: FirebaseLostCommentService
    var commentList: [CommentResponseDTO] = []
    
    weak var delegate: CommentDetailViewControllerDelegate?
    
    init(firebaseCommentService: FirebaseLostCommentService, lost: Lost) {
        self.firebaseCommentService = firebaseCommentService
        self.lost = lost
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycle
    override func loadView() {
        view = commentDetailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        getCommentList()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
        guard let lastCommet = commentList.last else { return }
        
        delegate?.dismissCommetnDetailViewController(lastComment: lastCommet)
    }
    
    func getCommentList() {
        Task {
            do {
                commentList = try await firebaseCommentService.fetchComments(lostIdentifier: lost.lostIdentifier)
                commentDetailView.commentTableView.reloadData()
            } catch {
                print(error)
            }
        }
    }
    
//    func commentAlert() {
//        guard let user = CurrentUserInfo.shared.currentUser else { return }
//        
//        guard let lastComment = commentList.last else {
//            return
//        }
//        guard user.identifier == lost.userIdentifier else {
//            return
//        }
//        guard user.identifier != lastComment.userIdentifier else {
//            return
//        }
//        UNUserNotificationCenter.current().addNotificationRequest(title: lastComment.userNickname, body: lastComment.commentDescription, id: lastComment.commentIdentifier)
//    }
}

// MARK: - Private Method
private extension CommentDetailViewController {
    func configure() {
        getCommentList()
        
        view.backgroundColor = .white
        
        configureTalbeView()
        configureActions()
        
        commentDetailView.myProfileImageView.kf.setImage(with: URL(string: CurrentUserInfo.shared.currentUser!.profileImageURL))
    }
    
    func configureActions() {
        commentDetailView.rightButtonItem.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        commentDetailView.commentSendButton.addTarget(self, action: #selector(commentSendButtonTapped), for: .touchUpInside)
        
        commentDetailView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    func configureTalbeView() {
        commentDetailView.commentTableView.dataSource = self
        commentDetailView.commentTableView.delegate = self
    }
    
    func setText(text: String) async throws {
        commentDetailView.writeCommentTextView.text = ""
        
        guard let user = CurrentUserInfo.shared.currentUser else { throw PetError.noUser }
        
        try await firebaseCommentService.createComment(commentResponseDTO: CommentResponseDTO(lostIdentifier: lost.lostIdentifier, userIdentifier: user.identifier, userProfileImageURL: user.profileImageURL, userNickname: user.nickname, commentDescription: text, commentDate: Date()))
    }
}

// MARK: - Actions
extension CommentDetailViewController {
    @objc func rightButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func keyboardUp(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            
            UIView.animate(
                withDuration: 0.3
                , animations: {
                    self.commentDetailView.myCommentTextView.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle.height)
                }
            )
        }
    }
    
    @objc func keyboardDown(notification: NSNotification) {
        commentDetailView.myCommentTextView.transform = .identity
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func commentSendButtonTapped() {
        guard commentDetailView.writeCommentTextView.text != "" else { return }
        
        Task {
            do {
                try await setText(text: commentDetailView.writeCommentTextView.text)
                
                getCommentList()
            } catch {
                print(error)
            }
        }
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension CommentDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentDetailView.commentTableView.dequeueReusableCell(withIdentifier: CommentDetailTableViewCell.identifier, for: indexPath) as! CommentDetailTableViewCell
        let comment = commentList[indexPath.row]
        cell.configureCell(commentUserNickName: comment.userNickname, commentUserProfileImageUrl: comment.userProfileImageURL, commentDescription: comment.commentDescription, commentTime: "\(comment.commentDate)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}


