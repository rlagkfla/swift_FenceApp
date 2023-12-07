//
//  UserDTO.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/19/23.
//

import UIKit



struct UserResponseDTO {
    
    let email: String
    var profileImageURL: String
    let identifier: String
    var nickname: String
    var userFCMToken: String
    var reportCount: Int
    
    
    init(email: String, profileImageURL: String, identifier: String, nickname: String, userFCMToken: String, reportCount: Int = 0) {
        self.email = email
        self.profileImageURL = profileImageURL
        self.identifier = identifier
        self.nickname = nickname
        self.userFCMToken = userFCMToken
        self.reportCount = reportCount
    }
    
 
}
