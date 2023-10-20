//
//  UserStoring.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/19/23.
//

import UIKit

struct UserStoringDTO {
    
    let email: String
    var profileImage: UIImage
    let identifier: String
    var nickname: String
    
    static var dummyUserStoring: [UserStoringDTO] = [
        UserStoringDTO(email: "aaa@gmail.com", profileImage: UIImage(systemName: "house")!, identifier: "user1", nickname: "user1"),
        UserStoringDTO(email: "bbb@gmail.com", profileImage: UIImage(systemName: "house")!, identifier: "user2", nickname: "user2"),
        UserStoringDTO(email: "ccc@gmail.com", profileImage: UIImage(systemName: "house")!, identifier: "user3", nickname: "user3"),
        UserStoringDTO(email: "ddd@gmail.com", profileImage: UIImage(systemName: "house")!, identifier: "user4", nickname: "user4"),
        UserStoringDTO(email: "eee@gmail.com", profileImage: UIImage(systemName: "house")!, identifier: "user5", nickname: "user5"),
    ]
}

// 유저가 사진을 찍거든요 uiimage -> (model, uiimage) -> uiimage url (model + url)
