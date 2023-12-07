//
//  CommentDTO.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/19/23.
//

import Foundation


struct CommentResponseDTO {
    
    let lostIdentifier: String
    let commentIdentifier: String
    let userIdentifier: String
    var userProfileImageURL: String
    var userNickname: String
    var commentDescription: String
    let commentDate: Date
    
    
    
    /// 얘는 받아올때 쓰는용도
    
    init(lostIdentifier: String, commentIdentifier: String = UUID().uuidString, userIdentifier: String, userProfileImageURL: String, userNickname: String, commentDescription: String, commentDate: Date) {
        self.lostIdentifier = lostIdentifier
        self.commentIdentifier = commentIdentifier
        self.userIdentifier = userIdentifier
        self.userProfileImageURL = userProfileImageURL
        self.userNickname = userNickname
        self.commentDescription = commentDescription
        self.commentDate = commentDate
    }
    
    /// 저장할때 쓰는용도
    init(lostIdentifier: String, userIdentifier: String, userProfileImageURL: String, userNickname: String, commentDescription: String, commentDate: Date) {
        
        self.commentIdentifier = UUID().uuidString
        self.lostIdentifier = lostIdentifier
        self.userIdentifier = userIdentifier
        self.userProfileImageURL = userProfileImageURL
        self.userNickname = userNickname
        self.commentDescription = commentDescription
        self.commentDate = commentDate
    }
    
}
