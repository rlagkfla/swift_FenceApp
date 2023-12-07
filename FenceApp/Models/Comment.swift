//
//  Comment.swift
//  FenceApp
//
//  Created by Woojun Lee on 11/2/23.
//

import Foundation

struct Comment: Equatable, Hashable {
    
    let lostIdentifier: String
    let commentIdentifier: String
    let userIdentifier: String
    var userProfileImageURL: String
    var userNickname: String
    var commentDescription: String
    let commentDate: Date
    
    static func == (lhs: Comment, rhs: Comment) -> Bool {
        return lhs.commentIdentifier == rhs.commentIdentifier
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(commentIdentifier)
    }
}
