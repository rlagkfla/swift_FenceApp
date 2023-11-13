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
    let lostIdentifier: String
    let firebaseLostCommentService: FirebaseLostCommentService
    
    init(lostIdentifier: String, firebaseLostCommentService: FirebaseLostCommentService) {
        self.lostIdentifier = lostIdentifier
        self.firebaseLostCommentService = firebaseLostCommentService
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
    
    @objc func keyboardUp(notification: NSNotification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            
            UIView.animate(
                withDuration: 0.3
                , animations: {
                    self.mainView.commentTextFieldView.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle.height + 55)
                }
            )
        }
    }
    
    @objc func keyboardDown(notification: NSNotification) {
        self.mainView.commentTextFieldView.transform = .identity
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
   
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        mainView.commentTextFieldView.textView.resignFirstResponder()
    }
    
    private func connectCollectionView() {
        mainView.collectionView.dataSource = self
        
    }
    
    private func getComments() async throws {
        let commentResponseDTOs = try await firebaseLostCommentService.fetchComments(lostIdentifier: lostIdentifier)
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
        header.hideIcon()
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        comments.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CommentCell.identifier, for: indexPath) as! CommentCell
        
        let comment = comments[indexPath.item]
        
        cell.setLabel(urlString: comment.userProfileImageURL, nickName: comment.userNickname, description: comment.commentDescription, date: comment.commentDate)
        
        return cell
    }
}

