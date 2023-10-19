//
//  FirebaseImageUploader.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/18/23.
//

import UIKit
import FirebaseStorage

struct FirebaseImageUploader {
    
    func uploadProfileImage(image: UIImage) async throws -> String {
        guard let imageData = image.jpegData(compressionQuality: 0.75) else { throw PetError.invalidImage }
        
        let fileName = UUID().uuidString
        
        let ref = Storage.storage().reference(withPath: "/profile_images/\(fileName)")
        
        let _ = try await ref.putDataAsync(imageData)
        
        let urlString = try await ref.downloadURL().absoluteString
        
        return urlString
    }
    
    
    
}
