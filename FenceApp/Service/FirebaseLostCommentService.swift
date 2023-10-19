//
//  FirebaseLostCommentService.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/18/23.
//

import Foundation

struct FirebaseLostCommentService {
    
    
    func createComment(lostIdentifier: String, comment: Comment) async throws {
        
        let data: [String: Any] = ["commentIdentifier": comment.commentIdentifier,
                                   "userIdentifier": comment.userIdentifier,
                                   "userProfileImageURL": comment.userProfileImageURL,
                                   "userNickname": comment.userNickname,
                                   "description": comment.description,
                                   "date": comment.date]
        
        COLLECTION_LOST.document(lostIdentifier).collection("comments").addDocument(data: data)
    }
}
