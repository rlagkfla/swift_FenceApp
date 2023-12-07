//
//  FoundDTO.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/19/23.
//

import Foundation

struct FoundResponseDTO {
    
    var latitude: Double
    var longitude: Double
    var imageURL: String
    let date: Date
    let userIdentifier: String
    let foundIdentifier: String
    let userProfileImageURL: String
    let userNickname: String
    
    init(latitude: Double, longitude: Double, imageURL: String, date: Date, userIdentifier: String, foundIdentifier: String, userProfileImageURL: String, userNickname: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.imageURL = imageURL
        self.date = date
        self.userIdentifier = userIdentifier
        self.foundIdentifier = foundIdentifier
        self.userProfileImageURL = userProfileImageURL
        self.userNickname = userNickname
    }
    
    init(latitude: Double, longitude: Double, imageURL: String, date: Date, userIdentifier: String, userProfileImageURL: String, userNickname: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.imageURL = imageURL
        self.date = date
        self.userIdentifier = userIdentifier
        self.foundIdentifier = UUID().uuidString
        self.userProfileImageURL = userProfileImageURL
        self.userNickname = userNickname
    }
   

}
