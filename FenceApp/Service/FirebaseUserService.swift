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
    
    func createUser(nickname: String, profileImageURL: String, authDataResult: AuthDataResult) async throws {
        
        guard let email = authDataResult.user.email else { throw PetError.noUser }
        
        let data: [String: Any] = ["email": email,
                                   "nickname": nickname,
                                   "profileImageUrl": profileImageURL,
                                   "identifier": authDataResult.user.uid]
        
        try await COLLECTION_USERS.document(authDataResult.user.uid).setData(data)
    }
}
