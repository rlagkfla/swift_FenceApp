//
//  firebaseFoundService.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/18/23.
//

import Foundation
import FirebaseFirestore

struct FirebaseLostService {
    
    let firebaseImageUploader: FirebaseImageUploadService
    
    func createLost(lostStoringDTO: LostStoringDTO) async throws {
        
        let urlString = try await firebaseImageUploader.uploadLostImage(image: lostStoringDTO.picture)
        
        let lostResponseDTO = LostResponseDTO(lostIdentifier: lostStoringDTO.lostIdentifier, latitude: lostStoringDTO.latitude, longitude: lostStoringDTO.longitude, userIdentifier: lostStoringDTO.userIdentifier, userProfileURL: lostStoringDTO.userProfileURL, userNickName: lostStoringDTO.userNickName, title: lostStoringDTO.title, postDate: lostStoringDTO.postDate, lostDate: lostStoringDTO.lostDate, pictureURL: urlString, petName: lostStoringDTO.petName, description: lostStoringDTO.description, kind: lostStoringDTO.kind)
        
        try await _createLost(lostDTO: lostResponseDTO)
    }
    
    func editUserInformationOnLostDTO(with userResponseDTO: UserResponseDTO, batch: WriteBatch) async throws {
        
        let refs = try await _fetchLosts(with: userResponseDTO.identifier)
        
        refs.forEach { ref in
            batch.updateData([FB.Lost.userProfileImageURL: userResponseDTO.profileImageURL, FB.Lost.userNickName: userResponseDTO.nickname], forDocument: ref)
        }
    }
    
    private func _fetchLosts(with userIdentifier: String) async throws -> [DocumentReference] {
        
        let query = COLLECTION_LOST.whereField(FB.Lost.userIdentifier, isEqualTo: userIdentifier)
        
        let documents = try await query.getDocuments().documents
        
        let identifiers = documents.map { document in
            document.data()[FB.Lost.lostIdentifier] as? String ?? ""
        }
        
        let refs = identifiers.map { identifier in
            COLLECTION_LOST.document(identifier)
        }
        
        return refs
    }
    
    private func _createLost(lostDTO: LostResponseDTO) async throws {
        
        let data: [String: Any] = [FB.Lost.lostIdentifier: lostDTO.lostIdentifier,
                                   FB.Lost.latitude: lostDTO.latitude,
                                   FB.Lost.longitude: lostDTO.longitude,
                                   FB.Lost.userIdentifier: lostDTO.userIdentifier,
                                   FB.Lost.userProfileImageURL: lostDTO.userProfileImageURL,
                                   FB.Lost.userNickName: lostDTO.userNickName,
                                   FB.Lost.title: lostDTO.title,
                                   FB.Lost.postDate: Timestamp(date: lostDTO.postDate),
                                   FB.Lost.lostDate: Timestamp(date: lostDTO.lostDate),
                                   FB.Lost.pictureURL: lostDTO.pictureURL,
                                   FB.Lost.petName: lostDTO.petName,
                                   FB.Lost.lostDescription: lostDTO.description,
                                   FB.Lost.kind: lostDTO.kind]
        
        try await COLLECTION_LOST.document(lostDTO.lostIdentifier).setData(data)
    }
    
    init(firebaseImageUploader: FirebaseImageUploadService) {
        self.firebaseImageUploader = firebaseImageUploader
    }
}
