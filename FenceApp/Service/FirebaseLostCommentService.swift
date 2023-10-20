//
//  FirebaseLostCommentService.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/18/23.
//

import Foundation
import FirebaseFirestore

struct FirebaseLostCommentService {
    
    let firebaseImageUploadService: FirebaseImageUploadService
    
    func createComment(commentDTO: CommentResponseDTO) async throws {
        
        let data: [String: Any] = [FB.Comment.lostIdentifier: commentDTO.lostIdentifier,
                                   FB.Comment.commentIdentifier: commentDTO.commentIdentifier,
                                   FB.Comment.userIdentifier: commentDTO.userIdentifier,
                                   FB.Comment.userProfileImageURL: commentDTO.userProfileImageURL,
                                   FB.Comment.userNickname: commentDTO.userNickname,
                                   FB.Comment.commentDescription: commentDTO.commentDescription,
                                   FB.Comment.commentDate: commentDTO.commentDate]
        
        try await COLLECTION_LOST.document(commentDTO.lostIdentifier).collection(FB.Collection.commentList).document(commentDTO.commentIdentifier).setData(data)
    }
    
    func editUserInformationOnComments(with userResponseDTO: UserResponseDTO, batch: WriteBatch) async throws {
        
        let refs = try await _fetchComments(with: userResponseDTO.identifier)
        
        refs.forEach { ref in
            batch.updateData([FB.Comment.userProfileImageURL: userResponseDTO.profileImageURL, FB.Comment.userNickname: userResponseDTO.nickname], forDocument: ref)
        }
    }
    
    func fetchComments(lostIdentifier: String) async throws -> [CommentResponseDTO] {
        
        let documents = try await COLLECTION_LOST.document(lostIdentifier).collection(FB.Collection.commentList).getDocuments().documents
        
        let comments = documents.map { CommentResponseDTO(dictionary: $0.data()) }
        
        return comments
    }
    
    private func _fetchComments(with userIdentifier: String) async throws -> [DocumentReference] {
        
        let query = COLLECTION_GROUP_COMMENTS.whereField(FB.Comment.userIdentifier, isEqualTo: userIdentifier)
        
        let documents = try await query.getDocuments().documents
        
        let refs = documents.map { document in
            
            let lostIdentifier = document.data()[FB.Comment.lostIdentifier] as? String ?? ""
            let commentIdentifier = document.data()[FB.Comment.commentIdentifier] as? String ?? ""
            
            print(lostIdentifier, "%%%%")
            
            return COLLECTION_LOST.document(lostIdentifier).collection(FB.Collection.commentList).document(commentIdentifier)
            
        }
        
        return refs
    }
    
    init(firebaseImageUploadService: FirebaseImageUploadService) {
        self.firebaseImageUploadService = firebaseImageUploadService
    }
    
    
}
