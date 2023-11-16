//
//  LostLastDocument.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/27/23.
//

import Foundation
import FirebaseFirestore

struct LostWithDocument {
    
    let lostResponseDTOs: [LostResponseDTO]
    let lastDocument: DocumentSnapshot
}
