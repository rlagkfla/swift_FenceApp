//
//  CommentViewController.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/19/23.
//

import UIKit
import SnapKit
import FirebaseMessaging

protocol CommentDetailViewControllerDelegate: AnyObject {
    func dismissCommetnDetailViewController(lastComment: CommentResponseDTO)
}

final class CommentDetailViewController: UIViewController {
    
    // MARK: - Properties
    private let commentDetailView = CommentDetailView()
    
    let lost: Lost
    
    let firebaseCloudMessaging = FirebaseCloudMessaging()
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        commentDetailView.writeCommentTextView.resignFirstResponder()
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
    
//    func sendCommentMessaing(comment: String) {
//        let serverKey = "AAAAZ4CjZqE:APA91bEW-e0wS7MSHeg2SpcMkQSQzSy0JiK448yYW6ZxnXc1eKkQ4u_jw1t5BV_rDpF0OtMS9aNLz31UaWMthSDXCeem5vpndqN6l_lqN3bxr6pI-hWxIFypAE225of79de-GdSf4hZd"
//        let url = URL(string: "https://fcm.googleapis.com/fcm/send")!
//        
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        let message: [String: Any] = [
//            "to": "dRzx-Jiwg007tJuBdTNkmJ:APA91bHHIz8yNEkBB6UUm8qMfrHB2EBV7Uka81kg8qf-ppZcFI_b_l5dbiWXZ1nqj9CPjezAbhguXsmPr5-IjCr2HkGo3sMQQNj6LYDH8-o51dmGrWq__8RDS9XZMo3mjLqxROLn1RhE",
//            "notification": [
//                "title": "\(lost.title)",
//                "body": "\(comment)"
//            ]
//        ]
//        
//        let jsonData = try! JSONSerialization.data(withJSONObject: message)
//        request.httpBody = jsonData
//        
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
//            if let error = error {
//                print("FCM 메시지 전송 오류: \(error.localizedDescription)")
//            } else if let data = data {
//                let responseJSON = try? JSONSerialization.jsonObject(with: data)
//                if let responseJSON = responseJSON as? [String: Any] {
//                    print("FCM 메시지 전송 성공: \(responseJSON)")
//                }
//            }
//        }
//        
//        task.resume()
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
        commentDetailView.writeCommentTextView.delegate = self
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
        guard let comment = commentDetailView.writeCommentTextView.text else { return }
        guard commentDetailView.writeCommentTextView.textColor == .black else { return }
        guard commentDetailView.writeCommentTextView.text != "" else { return }
        
        Task {
            do {
                try await setText(text: commentDetailView.writeCommentTextView.text)
                getCommentList()
                try await firebaseCloudMessaging.sendCommentMessaing(userToken: "eSbkl2CFN0S3i7mNfs9xap:APA91bE0QjujSJaB5GXa_8su2XbBNI7wjMg7m2w_vlRKcuF2j_zHz5B11M2fTYyQLv7q3PMYjP1K9IUgfZAMQ98x_2edX0MsaE_dtcsB13WLhj_vgB53UM0ROFZPtazC8rktLmo39Dkk", title: lost.title, comment: comment)
            } catch {
                print(error)
            }
        }
    }
}

extension CommentDetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if commentDetailView.writeCommentTextView.text == "댓글을 입력해주세요." {
            commentDetailView.writeCommentTextView.text = ""
            commentDetailView.writeCommentTextView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if commentDetailView.writeCommentTextView.text.isEmpty {
            commentDetailView.writeCommentTextView.text = "댓글을 입력해주세요."
            commentDetailView.writeCommentTextView.textColor = .lightGray
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


