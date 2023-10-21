//
//  FoundDTO.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/19/23.
//

import Foundation
import FirebaseFirestore
struct FoundResponseDTO {
    
    var latitude: Double
    var longitude: Double
    let imageURL: String
    let date: Date
    let userIdentifier: String
    let foundIdentifier: String
    
    init(latitude: Double, longitude: Double, imageURL: String, date: Date, userIdentifier: String, foundIdentifier: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.imageURL = imageURL
        self.date = date
        self.userIdentifier = userIdentifier
        self.foundIdentifier = foundIdentifier
    }
   
    init(dictionary: [String: Any]) {
        self.latitude = dictionary[FB.Found.latitude] as? Double ?? 0
        self.longitude = dictionary[FB.Found.longitude] as? Double ?? 0
        self.imageURL = dictionary[FB.Found.imageURL] as? String ?? ""
        self.date = (dictionary[FB.Found.date] as? Timestamp)?.dateValue() ?? Date()
        self.userIdentifier = dictionary[FB.Found.userIdentifier] as? String ?? ""
        self.foundIdentifier = dictionary[FB.Found.foundIdentifier] as? String ?? ""
    }
    

    static var dummyFoundDTO: [FoundResponseDTO] = [
        FoundResponseDTO(latitude: 37.319562, longitude: 126.830221, imageURL: "https://mblogthumb-phinf.pstatic.net/MjAyMjAyMDdfMjEy/MDAxNjQ0MTk0Mzk2MzY3.WAeeVCu2V3vqEz_9[…]0aKX8B1w2oKQg.JPEG.41minit/1643900851960.jpg?type=w800", date: Calendar.current.date(byAdding: .day, value: 0, to: Date())!, userIdentifier: "user1", foundIdentifier: "found1"),
        FoundResponseDTO(latitude: 37.319228, longitude: 126.830198, imageURL: "https://mblogthumb-phinf.pstatic.net/MjAyMTEyMjJfNDcg/MDAxNjQwMTUwOTUzODg2.ywMUl6KPyDdljDTu[…]DPvsie3hsrzog.JPEG.41minit/1640142789090.jpg?type=w800", date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, userIdentifier: "user2", foundIdentifier: "found2"),
        FoundResponseDTO(latitude: 37.319203, longitude: 126.831058, imageURL: "https://mblogthumb-phinf.pstatic.net/MjAyMTAxMjZfMTUw/MDAxNjExNjM3NTgwMTE5.op7Uxlhw2azjEKH3[…]tndCaC0g.JPEG.yoonsu3454/20201231_115330.jpg?type=w800", date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, userIdentifier: "user3", foundIdentifier: "found3"),
        FoundResponseDTO(latitude: 37.319552, longitude: 127.831137, imageURL: "https://cdn.salgoonews.com/news/photo/202105/2904_7323_220.jpg", date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!, userIdentifier: "user4", foundIdentifier: "found4"),
        FoundResponseDTO(latitude: 37.319400, longitude: 126.830649, imageURL: "https://www.fitpetmall.com/wp-content/uploads/2023/02/CK_tc02730000546-edited-scaled.jpg", date: Calendar.current.date(byAdding: .day, value: -4, to: Date())!, userIdentifier: "user5", foundIdentifier: "found5"),
    ]
}
