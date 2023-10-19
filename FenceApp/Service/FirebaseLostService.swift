//
//  firebaseFoundService.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/18/23.
//

import Foundation
import FirebaseFirestore

struct FirebaseLostService {
    
    func createLost(lost: Lost) async throws {
        
        let data: [String: Any] = ["lostIdentifier": lost.lostIdentifier,
                                   "latitude": lost.latitude,
                                   "longitude": lost.longitude,
                                   "userIdentifier": lost.userIdentifier,
                                   "userProfileImageURL": lost.userProfileImageURL,
                                   "userNickname": lost.userNickname,
                                   "title": lost.title,
                                   "posdtDate": Timestamp(date: lost.postDate),
                                   "lostDate": Timestamp(date: lost.lostDate),
                                   "picture": lost.picture,
                                   "petName": lost.petName,
                                   "description": lost.description,
                                   "kind": "dog"]
                                                
        try await COLLECTION_LOST.document(lost.userIdentifier).setData(data)
    }
}
