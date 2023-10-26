//
//  firebaseFoundService.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/18/23.
//
import Foundation

struct FirebaseLostService {
    
    
    let firebaseLostCommentService: FirebaseLostCommentService
    
    func createLost(lostResponseDTO: LostResponseDTO) async throws {
        
        let dictionary = LostResponseDTOMapper.makeDictionary(from: lostResponseDTO)
        
        try await COLLECTION_LOST.document(lostResponseDTO.lostIdentifier).setData(dictionary)
    }
    
    
    func editUserInformationOnLostDTO(with userResponseDTO: UserResponseDTO, batchController: BatchController) async throws {
        
        let identifiers = try await _fetchLostsIdentifier(with: userResponseDTO.identifier)
        
        identifiers.forEach { identifier in
            batchController.batch.updateData([FB.Lost.userProfileImageURL: userResponseDTO.profileImageURL,
                                              FB.Lost.userNickName: userResponseDTO.nickname],
                                             forDocument: COLLECTION_LOST.document(identifier))
        }
    }
    
    
    func deleteLost(lostIdentifier: String) async throws {
        
        let batchController = BatchController()
        
        let ref = COLLECTION_LOST.document(lostIdentifier)
        
        batchController.batch.deleteDocument(ref)
        
        try await firebaseLostCommentService.deleteComments(lostIdentifier: lostIdentifier, batchController: batchController)
        
        try await batchController.batch.commit()
    }
    
    
    func editLost(on lostResponseDTO: LostResponseDTO) async throws {
        
        let dictionary = LostResponseDTOMapper.makeDictionary(from: lostResponseDTO)
        
        try await COLLECTION_LOST.document(lostResponseDTO.lostIdentifier).updateData(dictionary)
        
    }
    
    
    func deleteLosts(writtenBy userIdentifier: String, batchController: BatchController) async throws {
        
        let lostIdentifiers = try await _fetchLostsIdentifier(with: userIdentifier)
        
        await withThrowingTaskGroup(of: type(of: ())) { group in
            for lostIdentifier in lostIdentifiers {
                
                let ref = COLLECTION_LOST.document(lostIdentifier)
                
                batchController.batch.deleteDocument(ref)
                
                group.addTask {
                    try await firebaseLostCommentService.deleteComments(lostIdentifier: lostIdentifier, batchController: batchController)
                }
            }
        }
    }
    
    
    func listenToUpdateOn(userIdentifier: String, completion: @escaping (Result<[LostResponseDTO],Error>) -> Void) {
        COLLECTION_LOST.whereField(FB.Lost.userIdentifier, isEqualTo: userIdentifier).addSnapshotListener { snapshot, error in
            
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
                
                return LostResponseDTOMapper.makeLostResponseDTO(from: dictionary)
            }
            
            completion(.success(lostResponseDTOs))
        }
    }
    
    
    func fetchLosts() async throws -> [LostResponseDTO] {
        
        let documents = try await COLLECTION_LOST.getDocuments().documents
        
        let lostResponseDTOs = documents.map { document in
            return LostResponseDTOMapper.makeLostResponseDTO(from: document.data())
        }
        
        return lostResponseDTOs
        
        
    }
    
    func fetchLosts(within distance: Double, fromDate: Date, toDate: Date) async throws -> [LostResponseDTO] {
        
        let locationCalculator = LocationCalculator()
        
        let locationManager = LocationManager()
        
        guard let location = locationManager.fetchLocation() else { throw PetError.failTask }
        
        let a = locationCalculator.getLocationsOfSqaure(lat: location.latitude, lon: location.longitude, distance: distance)
        
        let ref = COLLECTION_LOST.whereField(FB.Lost.latitude, isLessThan: a.maxLat)
                                .whereField(FB.Lost.latitude, isGreaterThan: a.minLat)
        
        let documents = try await ref.getDocuments().documents
        
        let lostResponseDTOs = documents.map { document in
            return LostResponseDTOMapper.makeLostResponseDTO(from: document.data())
        }
        
        let filteredLostResponseDTOs = lostResponseDTOs.filter {
            let range = a.minLon...a.maxLon
            return range.contains($0.longitude) && $0.postDate <= toDate && $0.postDate >= fromDate
        }
        
        
        
        return filteredLostResponseDTOs
    }
    
    
    init(firebaseLostCommentService: FirebaseLostCommentService) {
        
        self.firebaseLostCommentService = firebaseLostCommentService
    }
    
    //MARK: - Helper
    
    func _fetchLostsIdentifier(with userIdentifier: String) async throws -> [String] {
        
        let query = COLLECTION_LOST.whereField(FB.Lost.userIdentifier, isEqualTo: userIdentifier)
        
        let documents = try await query.getDocuments().documents
        
        let identifiers = documents.map { document in
            document.data()[FB.Lost.lostIdentifier] as? String ?? ""
        }
        
        return identifiers
    }
}
    
    
    
    
    

