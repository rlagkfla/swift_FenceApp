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
    var pictureURL: String
    var petName: String
    var description: String
    var kind: String

    
 
    
    static var dummyLost: [LostResponseDTO] = [
        LostResponseDTO(lostIdentifier: "lost1",
                latitude: 37.317399,
                longitude: 126.830014,
                userIdentifier: UserResponseDTO.dummyUser[0].identifier,
                        userProfileImageURL: UserResponseDTO.dummyUser[0].profileImageURL,
                userNickName: UserResponseDTO.dummyUser[0].nickname,
                title: "title1",
                postDate: Calendar.current.date(byAdding: .day, value: 0, to: Date())!,
                lostDate: Calendar.current.date(byAdding: .day, value: 0, to: Date())!,
                pictureURL: "https://img.freepik.com/free-photo/isolated-happy-smiling-dog-white-background-portrait-4_1562-693.jpg",
                petName: "pet1",
                description: "description1",
                kind: "dog"),
        
        
        LostResponseDTO(lostIdentifier: "lost2",
                latitude: 37.316694,
                longitude: 126.829903,
                userIdentifier: UserResponseDTO.dummyUser[1].identifier,
                        userProfileImageURL: UserResponseDTO.dummyUser[1].profileImageURL,
                userNickName: UserResponseDTO.dummyUser[1].nickname,
                title: "title2",
                postDate: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
                lostDate: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
                pictureURL: "https://i.natgeofe.com/n/4f5aaece-3300-41a4-b2a8-ed2708a0a27c/domestic-dog_thumb_3x2.jpg",
                petName: "pet2",
                description: "description2",
                kind: "dog"),
        
        LostResponseDTO(lostIdentifier: "lost3",
                latitude: 37.316703,
                longitude: 126.830925,
                userIdentifier: UserResponseDTO.dummyUser[2].identifier,
                        userProfileImageURL: UserResponseDTO.dummyUser[2].profileImageURL,
                userNickName: UserResponseDTO.dummyUser[2].nickname,
                title: "title3",
                postDate: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
                lostDate: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
                pictureURL: "https://images.pexels.com/photos/2607544/pexels-photo-2607544.jpeg?cs=srgb&dl=pexels-simona-kidri%C4%8D-2607544.jpg&fm=jpg",
                petName: "pet3",
                description: "description3",
                kind: "dog"),
        
        LostResponseDTO(lostIdentifier: "lost4",
                latitude: 37.317363,
                longitude: 126.830993,
                userIdentifier: UserResponseDTO.dummyUser[3].identifier,
                        userProfileImageURL: UserResponseDTO.dummyUser[3].profileImageURL,
                userNickName: UserResponseDTO.dummyUser[3].nickname,
                title: "title4",
                postDate: Calendar.current.date(byAdding: .day, value: -3, to: Date())!,
                lostDate: Calendar.current.date(byAdding: .day, value: -3, to: Date())!,
                pictureURL: "https://cdn.salgoonews.com/news/photo/202105/2904_7323_220.jpg",
                petName: "pet4",
                description: "description4",
                kind: "dog"),
        
        LostResponseDTO(lostIdentifier: "lost5",
                latitude: 37.317010,
                longitude: 126.830442,
                userIdentifier: UserResponseDTO.dummyUser[4].identifier,
                        userProfileImageURL: UserResponseDTO.dummyUser[4].profileImageURL,
                userNickName: UserResponseDTO.dummyUser[4].nickname,
                title: "title5",
                postDate: Calendar.current.date(byAdding: .day, value: -4, to: Date())!,
                lostDate: Calendar.current.date(byAdding: .day, value: -4, to: Date())!,
                pictureURL: "https://www.fitpetmall.com/wp-content/uploads/2023/02/CK_tc02730000546-edited-scaled.jpg",
                petName: "pet5",
                description: "description5",
                kind: "dog")
    ]
}
