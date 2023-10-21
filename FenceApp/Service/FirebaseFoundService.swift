//
//  FirebaseFoundService.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/18/23.
//

import Foundation

struct FirebaseFoundService {
    
    let firebaseImageUploadService: FirebaseImageUploadService
    
    func createFound(foundStoring: FoundStoringDTO) async throws {
        
        let urlString = try await firebaseImageUploadService.uploadeFoundImage(image: foundStoring.image)
        
        let foundResponseDTO = FoundResponseDTO(latitude: foundStoring.latitude, longitude: foundStoring.longitude, imageURL: urlString, date: foundStoring.date, userIdentifier: foundStoring.userIdentifier, foundIdentifier: foundStoring.foundIdentifier)
        
        try await _createFound(foundResponseDTO: foundResponseDTO)
    }
    
    func fetchFound(foundIdentifier: String) async throws -> FoundResponseDTO {
        
        guard let dictionary = try await COLLECTION_FOUND.document(foundIdentifier).getDocument().data() else { throw PetError.noSnapshotDocument}
        
        let foundDTO = FoundResponseDTO(dictionary: dictionary)
        
        return foundDTO
    }
    
    
    private func _createFound(foundResponseDTO: FoundResponseDTO) async throws {
        
        let data: [String: Any] = [FB.Found.latitude: foundResponseDTO.latitude,
                                   FB.Found.longitude: foundResponseDTO.longitude,
                                   FB.Found.imageURL: foundResponseDTO.imageURL,
                                   FB.Found.date: foundResponseDTO.date,
                                   FB.Found.userIdentifier: foundResponseDTO.userIdentifier,
                                   FB.Found.foundIdentifier: foundResponseDTO.foundIdentifier]
        
        try await COLLECTION_FOUND.document(foundResponseDTO.foundIdentifier).setData(data)
    }
    
    
    init(firebaseImageUploadService: FirebaseImageUploadService) {
        self.firebaseImageUploadService = firebaseImageUploadService
    }
}




