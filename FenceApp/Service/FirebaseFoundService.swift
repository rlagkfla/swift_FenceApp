//
//  FirebaseFoundService.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/18/23.
//

import Foundation
import FirebaseFirestore


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
    
    func fetchFounds(filterModel: FilterModel) async throws -> [FoundResponseDTO] {
        
        let locationManager = LocationManager()
        
        guard let location = locationManager.fetchLocation() else { throw PetError.failTask }
        
        let a = LocationCalculator.getLocationsOfSqaure(lat: location.latitude, lon: location.longitude, distance: filterModel.distance)
        
        let ref = COLLECTION_FOUND.whereField(FB.Found.latitude, isLessThan: a.maxLat)
                                .whereField(FB.Found.latitude, isGreaterThan: a.minLat)
        
        let documents = try await ref.getDocuments().documents
        
        let foundResponseDTOs = documents.map { document in
            
            return FoundResponseDTOMapper.makeFoundResponseDTOs(dictionary: document.data())
        }
        
        let b = foundResponseDTOs.filter {

            let range = a.minLon...a.maxLon
            
            return range.contains($0.longitude) && $0.date <= filterModel.endDate && $0.date >= filterModel.startDate
        }
      
        return b
    }
    
    
    func fetchFounds(within distance: Double, fromDate: Date, toDate: Date) async throws -> [FoundResponseDTO] {
        
        
        let locationManager = LocationManager()
        
        guard let location = locationManager.fetchLocation() else { throw PetError.failTask }
        let a = LocationCalculator.getLocationsOfSqaure(lat: location.latitude, lon: location.longitude, distance: distance)
        let ref = COLLECTION_FOUND.whereField(FB.Found.latitude, isLessThan: a.maxLat)
                                .whereField(FB.Found.latitude, isGreaterThan: a.minLat)
        
        let documents = try await ref.getDocuments().documents
        
        let foundResponseDTOs = documents.map { document in
            
            return FoundResponseDTOMapper.makeFoundResponseDTOs(dictionary: document.data())
        }
        
        let b = foundResponseDTOs.filter {

            let range = a.minLon...a.maxLon
            
            return range.contains($0.longitude) && $0.date <= toDate && $0.date >= fromDate
        }
      
        return b
    }
    
    func fetchFoundsWithPagination(int: Int, lastDocument: DocumentSnapshot? = nil) async throws -> FoundWithDocument {
        
        var ref = COLLECTION_FOUND.limit(to: int)
        
        if let lastDocument {
            ref = ref.start(afterDocument: lastDocument)
        }
        let snapshot = try await ref.getDocuments()
        
        let documents = snapshot.documents
        
        guard let lastDocument = documents.last else { throw PetError.noSnapshotDocument }
        
        let foundResponseDTOs = documents.map { document in
            return FoundResponseDTOMapper.makeFoundResponseDTOs(dictionary: document.data())
        }
        
        return FoundWithDocument(foundResponseDTOs: foundResponseDTOs, lastDocument: lastDocument)
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




