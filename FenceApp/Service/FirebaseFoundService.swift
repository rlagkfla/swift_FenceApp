//
//  FirebaseFoundService.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/18/23.
//

import Foundation

struct FirebaseFoundService {
    
    let foundResponseDTOMapper: FoundResponseDTOMapper
    
    
    func fetchFound(foundIdentifier: String) async throws -> FoundResponseDTO {
        
        guard let dictionary = try await COLLECTION_FOUND.document(foundIdentifier).getDocument().data() else { throw PetError.noSnapshotDocument}
        
        let foundResponseDTO = foundResponseDTOMapper.makeFoundResponseDTOs(dictionary: dictionary)
        
        return foundResponseDTO
    }
    
    
    func createFound(foundResponseDTO: FoundResponseDTO) async throws {
        
        let dictionary = foundResponseDTOMapper.makeDictionary(foundResponseDTO: foundResponseDTO)
        
        try await COLLECTION_FOUND.document(foundResponseDTO.foundIdentifier).setData(dictionary)
    }
    
    func listenToUpdateOn(userIdentifier: String, completion: @escaping (Result<[FoundResponseDTO],Error>) -> Void) {
        
        COLLECTION_FOUND.whereField(FB.Found.userIdentifier, isEqualTo: userIdentifier).addSnapshotListener { snapshot, error in
            
            if let error {
                completion(.failure(error))
                return
            }
            
            
            guard let documents = snapshot?.documents else {
                completion(.failure(PetError.noSnapshotDocument))
                return
            }
            
            let lostResponseDTOs = documents.map { document in
                
                let dictionary = document.data()
                
                return foundResponseDTOMapper.makeFoundResponseDTOs(dictionary: dictionary)
            }
            
            completion(.success(lostResponseDTOs))
            
            
        }
    }
    
    
    init(foundResponseDTOMapper: FoundResponseDTOMapper) {
        self.foundResponseDTOMapper = foundResponseDTOMapper
    }
}




