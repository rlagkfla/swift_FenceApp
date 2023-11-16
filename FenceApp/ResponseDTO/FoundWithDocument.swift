//
//  FoundWithDocument.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/27/23.
//

import Foundation
import FirebaseFirestore

struct FoundWithDocument {
    
    let foundResponseDTOs: [FoundResponseDTO]
    let lastDocument: DocumentSnapshot
    
}
