//
//  CurrentUserInfo.swift
//  FenceApp
//
//  Created by Woojun Lee on 11/1/23.
//

import Foundation

class CurrentUserInfo {
    
    static let shared = CurrentUserInfo()
    
    var currentUser: UserResponseDTO?
    
    private init() {}
}
