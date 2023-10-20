//
//  FoundStoring.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/19/23.
//

import UIKit

struct FoundStoringDTO {
    
    var latitude: Double
    var longitude: Double
    let image: UIImage
    let date: Date
    let userIdentifier: String
    let foundIdentifier: String
    
    static var dummyFoundDTO: [FoundStoringDTO] = [
        FoundStoringDTO(latitude: 37.319562, longitude: 126.830221, image: UIImage(systemName: "house")!, date: Calendar.current.date(byAdding: .day, value: 0, to: Date())!, userIdentifier: "user1", foundIdentifier: "found1"),
        FoundStoringDTO(latitude: 37.319228, longitude: 126.830198, image: UIImage(systemName: "house")!, date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, userIdentifier: "user2", foundIdentifier: "found2"),
        FoundStoringDTO(latitude: 37.319203, longitude: 126.831058, image: UIImage(systemName: "house")!, date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, userIdentifier: "user3", foundIdentifier: "found3"),
        FoundStoringDTO(latitude: 37.319552, longitude: 127.831137, image: UIImage(systemName: "house")!, date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!, userIdentifier: "user4", foundIdentifier: "found4"),
        FoundStoringDTO(latitude: 37.319400, longitude: 126.830649, image: UIImage(systemName: "house")!, date: Calendar.current.date(byAdding: .day, value: -4, to: Date())!, userIdentifier: "user5", foundIdentifier: "found5"),
    ]
}
