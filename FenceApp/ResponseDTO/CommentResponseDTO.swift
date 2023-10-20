//
//  CommentDTO.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/19/23.
//

import Foundation
import FirebaseFirestore

struct CommentResponseDTO {
    
    let lostIdentifier: String
    let commentIdentifier: String
    let userIdentifier: String
    var userProfileImageURL: String
    var userNickname: String
    var commentDescription: String
    let commentDate: Date
    
    init(lostIdentifier: String, commentIdentifier: String, userIdentifier: String, userProfileImageURL: String, userNickname: String, description: String, date: Date) {
        self.lostIdentifier = lostIdentifier
        self.commentIdentifier = commentIdentifier
        self.userIdentifier = userIdentifier
        self.userProfileImageURL = userProfileImageURL
        self.userNickname = userNickname
        self.commentDescription = description
        self.commentDate = date
    }
    
    init(dictionary: [String: Any]) {
        self.lostIdentifier = dictionary[FB.Comment.lostIdentifier] as? String ?? ""
        self.commentIdentifier = dictionary[FB.Comment.commentIdentifier] as? String ?? ""
        self.userIdentifier = dictionary[FB.Comment.userIdentifier] as? String ?? ""
        self.userProfileImageURL = dictionary[FB.Comment.userProfileImageURL] as? String ?? ""
        self.userNickname = dictionary[FB.Comment.userNickname] as? String ?? ""
        self.commentDescription = dictionary[FB.Comment.commentDescription] as? String ?? ""
        self.commentDate = (dictionary[FB.Comment.commentDate] as? Timestamp)?.dateValue() ?? Date()
    }
    
   
    
    static var dummyComment: [CommentResponseDTO] = [
        CommentResponseDTO(lostIdentifier: LostResponseDTO.dummyLost[0].lostIdentifier ,commentIdentifier: "comment1", userIdentifier: "user1", userProfileImageURL: "url1", userNickname: "nickname1", description: "description1", date: Calendar.current.date(byAdding: .day, value: 0, to: Date())!)
//        Comment(user: User.dummyUser[0], description: "description1", date: Calendar.current.date(byAdding: .day, value: 0, to: Date())!),
//        Comment(user: User.dummyUser[1], description: "description2", date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!),
//        Comment(user: User.dummyUser[2], description: "description3", date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!),
//        Comment(user: User.dummyUser[3], description: "description4", date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!),
//        Comment(user: User.dummyUser[4], description: "description5", date: Calendar.current.date(byAdding: .day, value: -4, to: Date())!),
    ]
}
