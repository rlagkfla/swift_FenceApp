//
//  CurrentUserInfo.swift
//  FenceApp
//
//  Created by Woojun Lee on 11/1/23.
//

import Foundation

class CurrentUserInfo {
    
    static let shared = CurrentUserInfo()
    
    var currentUser: FBUser?
    
    var userToken: String?
    
    var checkIfReportExceeed: Bool {
      
        guard let reportCount = currentUser?.reportCount else { return false }
        
        return reportCount >= 3 ? true : false
    }
    
    private init() {}
}
