//
//  LostDTO.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/19/23.
//

import Foundation

struct LostResponseDTO {
    
    let lostIdentifier: String
    var latitude: Double
    var longitude: Double
    var userIdentifier: String
    var userProfileImageURL: String
    var userNickName: String
    var title: String
    let postDate: Date
    var lostDate: Date
    var imageURL: String
    var petName: String
    var description: String
    var kind: String
    var userFCMToken: String

    
    // lostIdentifier가 자동으로 주어짐 데이터베이스 불러온 객체를 만듬
    
    init(lostIdentifier: String, latitude: Double, longitude: Double, userIdentifier: String, userProfileImageURL: String, userNickName: String, title: String, postDate: Date, lostDate: Date, pictureURL: String, petName: String, description: String, kind: String, userFCMToken: String) {
        self.lostIdentifier = lostIdentifier
        self.latitude = latitude
        self.longitude = longitude
        self.userIdentifier = userIdentifier
        self.userProfileImageURL = userProfileImageURL
        self.userNickName = userNickName
        self.title = title
        self.postDate = postDate
        self.lostDate = lostDate
        self.imageURL = pictureURL
        self.petName = petName
        self.description = description
        self.kind = kind
        self.userFCMToken = userFCMToken
    }
    
    // lostIdentifier가 자동으로 주어짐 저장하는 객체를 만들때 사용
    
    init(latitude: Double, longitude: Double, userIdentifier: String, userProfileImageURL: String, userNickName: String, title: String, postDate: Date, lostDate: Date, pictureURL: String, petName: String, description: String, kind: String, userFCMToken: String) {
        self.lostIdentifier = UUID().uuidString
        self.latitude = latitude
        self.longitude = longitude
        self.userIdentifier = userIdentifier
        self.userProfileImageURL = userProfileImageURL
        self.userNickName = userNickName
        self.title = title
        self.postDate = postDate
        self.lostDate = lostDate
        self.imageURL = pictureURL
        self.petName = petName
        self.description = description
        self.kind = kind
        self.userFCMToken = userFCMToken
    }
 
}
