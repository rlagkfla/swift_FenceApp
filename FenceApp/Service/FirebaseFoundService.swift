//
//  FirebaseFoundService.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/18/23.
//

import Foundation

struct FirebaseFoundService {
    
    
    
    func fetchFound(foundIdentifier: String) async throws -> FoundResponseDTO {
        
        guard let dictionary = try await COLLECTION_FOUND.document(foundIdentifier).getDocument().data() else { throw PetError.noSnapshotDocument}
        
        let foundResponseDTO = FoundResponseDTOMapper.makeFoundResponseDTOs(dictionary: dictionary)
        
        return foundResponseDTO
    }
    
    
    func fetchFounds() async throws -> [FoundResponseDTO] {
        
        let documents = try await COLLECTION_FOUND.getDocuments().documents
        
        let foundResponseDTOs = documents.map { document in
            FoundResponseDTOMapper.makeFoundResponseDTOs(dictionary: document.data())
        }
        
        return foundResponseDTOs
    }
    
    func fetchFounds(within distance: Double) async throws -> [FoundResponseDTO] {
        
        let locationCalculator = LocationCalculator()
        let locationManager = LocationManager()
        
        guard let location = locationManager.fetchLocation() else { throw PetError.failTask }
        let a = locationCalculator.getLocationsOfSqaure(lat: location.latitude, lon: location.longitude, distance: distance)
        let ref = COLLECTION_LOST.whereField(FB.Found.latitude, isLessThan: a.maxLat)
                                .whereField(FB.Found.latitude, isGreaterThan: a.minLat)
                                .whereField(FB.Found.longitude, isLessThan: a.maxLon)
                                .whereField(FB.Found.longitude, isGreaterThan: a.minLon)
        
        let documents = try await ref.getDocuments().documents
        
        let foundResponseDTOs = documents.map { document in
            
            return FoundResponseDTOMapper.makeFoundResponseDTOs(dictionary: document.data())
        }
        
        return foundResponseDTOs
    }
    
    
    func deleteFounds(writtenBy userIdentifier: String, batchController: BatchController) async throws {
        
        let ref = COLLECTION_FOUND.whereField(FB.Found.userIdentifier, isEqualTo: userIdentifier)
        
        let documents = try await ref.getDocuments().documents
        
        for document in documents {
            
            let foundIdentifier = document.data()[FB.Found.foundIdentifier] as? String ?? ""
            
            let ref = COLLECTION_FOUND.document(foundIdentifier)
            
            batchController.batch.deleteDocument(ref)
        }
    }
    
    
    func createFound(foundResponseDTO: FoundResponseDTO) async throws {
        
        let dictionary = FoundResponseDTOMapper.makeDictionary(foundResponseDTO: foundResponseDTO)
        
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
                
                return FoundResponseDTOMapper.makeFoundResponseDTOs(dictionary: dictionary)
            }
            
            completion(.success(lostResponseDTOs))
        }
    }
    
    
  
}




