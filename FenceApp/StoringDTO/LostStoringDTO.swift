//
//  LostStoring.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/19/23.
//

import UIKit

struct LostStoringDTO {
    
    let lostIdentifier: String
    var latitude: Double
    var longitude: Double
    var userIdentifier: String
    var userProfileURL: String
    var userNickName: String
    let title: String
    var postDate: Date
    let lostDate: Date
    var picture: UIImage
    var petName: String
    var description: String
    var kind: String
    
    static var dummyLostStoring: [LostStoringDTO] = [
        LostStoringDTO(lostIdentifier: "lost1",
                    latitude: 37.317399,
                    longitude: 126.830014,
                    userIdentifier: UserResponseDTO.dummyUser[0].identifier,
                    userProfileURL: UserResponseDTO.dummyUser[0].profileImageURL,
                    userNickName: UserResponseDTO.dummyUser[0].nickname,
                    title: "title1",
                    postDate: Calendar.current.date(byAdding: .day, value: 0, to: Date())!,
                    lostDate: Calendar.current.date(byAdding: .day, value: 0, to: Date())!,
                    picture: UIImage(systemName: "house")!,
                    petName: "pet1",
                    description: "description1",
                    kind: "dog"),
        
        
        LostStoringDTO(lostIdentifier: "lost2",
                    latitude: 37.316694,
                    longitude: 126.829903,
                    userIdentifier: UserResponseDTO.dummyUser[1].identifier,
                    userProfileURL: UserResponseDTO.dummyUser[1].profileImageURL,
                    userNickName: UserResponseDTO.dummyUser[1].nickname,
                    title: "title2",
                    postDate: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
                    lostDate: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
                    picture: UIImage(systemName: "house")!,
                    petName: "pet2",
                    description: "description2",
                    kind: "dog"),
        
        LostStoringDTO(lostIdentifier: "lost3",
                    latitude: 37.316703,
                    longitude: 126.830925,
                    userIdentifier: UserResponseDTO.dummyUser[2].identifier,
                    userProfileURL: UserResponseDTO.dummyUser[2].profileImageURL,
                    userNickName: UserResponseDTO.dummyUser[2].nickname,
                    title: "title3",
                    postDate: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
                    lostDate: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
                    picture: UIImage(systemName: "house")!,
                    petName: "pet3",
                    description: "description3",
                    kind: "dog"),
        
        LostStoringDTO(lostIdentifier: "lost4",
                    latitude: 37.317363,
                    longitude: 126.830993,
                    userIdentifier: UserResponseDTO.dummyUser[3].identifier,
                    userProfileURL: UserResponseDTO.dummyUser[3].profileImageURL,
                    userNickName: UserResponseDTO.dummyUser[3].nickname,
                    title: "title4",
                    postDate: Calendar.current.date(byAdding: .day, value: -3, to: Date())!,
                    lostDate: Calendar.current.date(byAdding: .day, value: -3, to: Date())!,
                    picture: UIImage(systemName: "house")!,
                    petName: "pet4",
                    description: "description4",
                    kind: "dog"),
        
        LostStoringDTO(lostIdentifier: "lost5",
                    latitude: 37.317010,
                    longitude: 126.830442,
                    userIdentifier: UserResponseDTO.dummyUser[4].identifier,
                    userProfileURL: UserResponseDTO.dummyUser[4].profileImageURL,
                    userNickName: UserResponseDTO.dummyUser[4].nickname,
                    title: "title5",
                    postDate: Calendar.current.date(byAdding: .day, value: -4, to: Date())!,
                    lostDate: Calendar.current.date(byAdding: .day, value: -4, to: Date())!,
                    picture: UIImage(systemName: "house")!,
                    petName: "pet5",
                    description: "description5",
                    kind: "dog")
    ]
}
