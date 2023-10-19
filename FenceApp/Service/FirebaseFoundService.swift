//
//  FirebaseFoundService.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/18/23.
//

import Foundation

struct FirebaseFoundService {
    
    func createFound(found: Found) async throws {
        
        let data: [String: Any] = ["latitude": found.latitude,
                                   "longitude": found.longitude,
                                   "imageURL": found.picture,
                                   "userIdentifier": found.userIdentifier,
                                   "foundIdentifier": found.foundIdentifier]
        
        try await COLLECTION_FOUND.document(found.foundIdentifier).setData(data)
    }
}
