//
//  firebaseFoundService.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/18/23.
//

struct FirebaseLostService {
    
    let lostResponseDTOMapper: LostResponseDTOMapper
    
    let firebaseLostCommentService: FirebaseLostCommentService
    
    func createLost(lostResponseDTO: LostResponseDTO) async throws {
        
        let dictionary = lostResponseDTOMapper.makeDictionary(from: lostResponseDTO)
        
        try await COLLECTION_LOST.document(lostResponseDTO.lostIdentifier).setData(dictionary)
    }
    
    func editUserInformationOnLostDTO(with userResponseDTO: UserResponseDTO, batchController: BatchController) async throws {
        
        let identifiers = try await _fetchLosts(with: userResponseDTO.identifier)
        
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
        
        let dictionary = lostResponseDTOMapper.makeDictionary(from: lostResponseDTO)
        
        try await COLLECTION_LOST.document(lostResponseDTO.lostIdentifier).updateData(dictionary)
        
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
                
                return lostResponseDTOMapper.makeLostResponseDTO(from: dictionary)
            }
            
            completion(.success(lostResponseDTOs))

        
        }
        
    }
    
    init(lostResponseDTOMapper: LostResponseDTOMapper, firebaseLostCommentService: FirebaseLostCommentService) {
        self.lostResponseDTOMapper = lostResponseDTOMapper
        self.firebaseLostCommentService = firebaseLostCommentService
    }
    
    //MARK: - Helper
    
    private func _fetchLosts(with userIdentifier: String) async throws -> [String] {
        
        let query = COLLECTION_LOST.whereField(FB.Lost.userIdentifier, isEqualTo: userIdentifier)
        
        let documents = try await query.getDocuments().documents
        
        let identifiers = documents.map { document in
            document.data()[FB.Lost.lostIdentifier] as? String ?? ""
        }
        
        return identifiers
    }
    
    
    
    
    
    
}
