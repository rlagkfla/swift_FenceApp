//
//  CommentViewController.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/19/23.
//

import UIKit
import SnapKit

class CommentDetailViewController: UIViewController {
    
    // MARK: - Properties
    private let commentDetailView = CommentDetailView()
    
    let lostResponseDTO: LostResponseDTO
    let firebaseCommentService: FirebaseLostCommentService
    var commentList: [CommentResponseDTO] = []
    
    init(firebaseCommentService: FirebaseLostCommentService, lostResponseDTO: LostResponseDTO) {
        self.firebaseCommentService = firebaseCommentService
        self.lostResponseDTO = lostResponseDTO
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
        
        getCommentList()
        
        view.backgroundColor = .white
        
        configureTalbeView()
        configureActions()
        
        commentDetailView.myProfileImageView.kf.setImage(with: URL(string: lostResponseDTO.userProfileImageURL))
        
        deleteCommet()
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
    
    private func configureActions() {
        commentDetailView.rightButtonItem.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)
        commentDetailView.commentSendButton.addTarget(self, action: #selector(commentSendButtonTapped), for: .touchUpInside)
        
        commentDetailView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    
    private func configureTalbeView() {
        commentDetailView.commentTableView.dataSource = self
        commentDetailView.commentTableView.delegate = self
    }
    
    func getCommentList() {
        Task {
            do {
                commentList = try await firebaseCommentService.fetchComments(lostIdentifier: lostResponseDTO.lostIdentifier)
                commentDetailView.commentTableView.reloadData()
            } catch {
                print(error)
            }
        }
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
        Task {
            do {
                try await firebaseCommentService.createComment(commentResponseDTO: CommentResponseDTO(lostIdentifier: lostResponseDTO.lostIdentifier, userIdentifier: lostResponseDTO.userIdentifier, userProfileImageURL: lostResponseDTO.userProfileImageURL, userNickname: lostResponseDTO.userNickName, commentDescription: commentDetailView.writeCommentTextView.text, commentDate: Date()))
                
                commentDetailView.commentTableView.reloadData()
                
            } catch {
                print(error)
            }
        }
        commentDetailView.writeCommentTextView.text = ""
        print(#function)
    }
    
    func deleteCommet() {
        Task {
            do {
                try await firebaseCommentService.deleteComments(lostIdentifier: lostResponseDTO.lostIdentifier, batchController: BatchController())
                commentDetailView.commentTableView.reloadData()
            } catch {
                print(error)
            }
        }
        
        print(#function)
    }
}

// MARK: - UITableViewDataSource
extension CommentDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = commentDetailView.commentTableView.dequeueReusableCell(withIdentifier: CommentDetailTableViewCell.identifier, for: indexPath) as! CommentDetailTableViewCell
        let comment = commentList[indexPath.row]
        cell.commenterNickName.text = comment.userNickname
        cell.commentUserProfileImageView.kf.setImage(with: URL(string: comment.userProfileImageURL))
        cell.commentTextLabel.text = comment.commentDescription
        cell.commentDate.text = "\(comment.commentDate)"
        return cell
    }
}


