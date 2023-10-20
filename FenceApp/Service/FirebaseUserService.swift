//
//  FirebaseUserService.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/18/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore


struct FirebaseUserService {
    
    let firebaseImageUploader: FirebaseImageUploadService
    let firebaseLostService: FirebaseLostService
    let firebaseLostCommentService: FirebaseLostCommentService
    
    func createUser(userStoringDTO: UserStoringDTO) async throws {
        
        let profileImageURL = try await firebaseImageUploader.uploadProfileImage(image: userStoringDTO.profileImage)
        
        let userResponseDTO = UserResponseDTO(email: userStoringDTO.email, profileImageURL: profileImageURL, identifier: userStoringDTO.identifier, nickname: userStoringDTO.nickname)
        
        try await _createUser(userResponseDTO: userResponseDTO)
    }
    
    func fetchUser(userIdentifier: String) async throws -> UserResponseDTO {
        
        guard let dictionary = try await COLLECTION_USERS.document(userIdentifier).getDocument().data() else { throw PetError.noSnapshotDocument }
        
        let userDTO = UserResponseDTO(dictionary: dictionary)
        
        return userDTO
    }
    
    func editUser(userResponseDTO: UserResponseDTO) async throws {
        
        let batch = Firestore.firestore().batch()
        
        _editUser(userResponseDTO: userResponseDTO, batch: batch)
        
        await withThrowingTaskGroup(of: type(of: ())) { group in
            
                group.addTask {
                    try await firebaseLostService.editUserInformationOnLostDTO(with: userResponseDTO, batch: batch)
                    try await firebaseLostCommentService.editUserInformationOnComments(with: userResponseDTO, batch: batch)
                }
            }
        
        try await batch.commit()
    }
    
    private func _editUser(userResponseDTO: UserResponseDTO, batch: WriteBatch) {
        let ref = COLLECTION_USERS.document(userResponseDTO.identifier)
        
        batch.updateData([FB.User.profileImageURL: userResponseDTO.profileImageURL, FB.User.userNickname: userResponseDTO.nickname], forDocument: ref)
        
    }
    
    private func _createUser(userResponseDTO: UserResponseDTO) async throws {
                
        let data: [String: Any] = [FB.User.email: userResponseDTO.email,
                                   FB.User.userNickname: userResponseDTO.nickname,
                                   FB.User.profileImageURL: userResponseDTO.profileImageURL,
                                   FB.User.useridentifier: userResponseDTO.identifier]
        
        try await COLLECTION_USERS.document(userResponseDTO.identifier).setData(data)
    }
    
    
    init(firebaseImageUploader: FirebaseImageUploadService, firebaseLostService: FirebaseLostService, firebaseLostCommentService: FirebaseLostCommentService) {
        self.firebaseImageUploader = firebaseImageUploader
        self.firebaseLostService = firebaseLostService
        self.firebaseLostCommentService = firebaseLostCommentService
    }
}
