//
//  Model.swift
//  FenceApp
//
//  Created by ㅣ on 2023/10/16.
//

import Foundation

struct User {
    var profileImage: String
    let identifier: String
    var nickname: String
    
    static var dummyUser: [User] = [
        User(profileImage: "https://i.namu.wiki/i/Qi6-ujIIuSfOQ5sh06m9T8umR8lLf_ryzzS9f7qmat0Npe9KLXSDxvovYGjj[…]gcqn9mgD0cUumJ27NyAf9hEiFBCSKgpjLh3p-Okl8Mn413VsGz-dodb6gA.webp", identifier: "user1", nickname: "user1"),
        User(profileImage: "https://i.namu.wiki/i/XGKcLALgTFEOwBFIC1PXIfjab1EKO53yGBXhKMEPeDQItwXjtZzCNUoijH4G[…]gbjhV9HTWN9j2-PZ6kB5Ap-UyB2m2gD_tlaYu7ImuiDJMeIywBeeEMl8Kw.webp", identifier: "user2", nickname: "user2"),
        User(profileImage: "https://i.namu.wiki/i/-5LMNb2M9lxLETGtKKHa6Nv1NfEiAvHMz38rb7dyZQCkcoqHsthPAYucW0jC[…]7ZNcaBdEiwgrg0NpFP5EXThsf31tIkc7d8gKaaDer8n7mo0NBfN9PpY_gw.webp", identifier: "user3", nickname: "user3"),
        User(profileImage: "https://i.namu.wiki/i/buRp-Z6r8egBOFmmqtsepfzhZaWGsPUiL5Tk30YJ-Pql1V2KwrGrLx51nOU5[…]PP3BzgZbXwni5AwlKtsQBk0mggfd9Q4F4qSBEGs9kEqAKgw-gS-QzzfXCw.webp", identifier: "user4", nickname: "user4"),
        User(profileImage: "https://i.namu.wiki/i/jo4uFuxhDeR8EQWONfp3eJNuU80L918RS_3q2kDpT8mGbesLBYG1Fyj3Zw3O[…]jTeG_3Lr5oO13j6UC6JkBS18PLrxSJL4-PntO3iQ6kVwEgjqXUzIzJoSRA.webp", identifier: "user5", nickname: "user5"),
    ]
}

struct Found {
    var latitude: Double
    var longitude: Double
    let picture: String
    let date: Date
    let userIdentifier: String
    let foundIdentifier: String
    
    static var dummyFound: [Found] = [
    Found(latitude: 37.319562, longitude: 126.830221, picture: "https://mblogthumb-phinf.pstatic.net/MjAyMjAyMDdfMjEy/MDAxNjQ0MTk0Mzk2MzY3.WAeeVCu2V3vqEz_9[…]0aKX8B1w2oKQg.JPEG.41minit/1643900851960.jpg?type=w800", date: Calendar.current.date(byAdding: .day, value: 0, to: Date())!, userIdentifier: "user1", foundIdentifier: "found1"),
    Found(latitude: 37.319228, longitude: 126.830198, picture: "https://mblogthumb-phinf.pstatic.net/MjAyMTEyMjJfNDcg/MDAxNjQwMTUwOTUzODg2.ywMUl6KPyDdljDTu[…]DPvsie3hsrzog.JPEG.41minit/1640142789090.jpg?type=w800", date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!, userIdentifier: "user2", foundIdentifier: "found2"),
    Found(latitude: 37.319203, longitude: 126.831058, picture: "https://mblogthumb-phinf.pstatic.net/MjAyMTAxMjZfMTUw/MDAxNjExNjM3NTgwMTE5.op7Uxlhw2azjEKH3[…]tndCaC0g.JPEG.yoonsu3454/20201231_115330.jpg?type=w800", date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!, userIdentifier: "user3", foundIdentifier: "found3"),
    Found(latitude: 37.319552, longitude: 127.831137, picture: "https://cdn.salgoonews.com/news/photo/202105/2904_7323_220.jpg", date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!, userIdentifier: "user4", foundIdentifier: "found4"),
    Found(latitude: 37.319400, longitude: 126.830649, picture: "https://www.fitpetmall.com/wp-content/uploads/2023/02/CK_tc02730000546-edited-scaled.jpg", date: Calendar.current.date(byAdding: .day, value: -4, to: Date())!, userIdentifier: "user5", foundIdentifier: "found5"),
    ]
}

struct Lost {
   
    let lostIdentifier: String
    var latitude: Double
    var longitude: Double
    let user: User
    let title: String
    var postDate: Date
    let lostDate: Date
    let picture: String
    var petName: String
    var description: String
    var kind: String
    
    static var dummyLost: [Lost] = [
    Lost(lostIdentifier: "lost1",
         latitude: 37.317399,
         longitude: 126.830014,
         user: User.dummyUser[0],
         title: "title1",
         postDate: Calendar.current.date(byAdding: .day, value: 0, to: Date())!,
         lostDate: Calendar.current.date(byAdding: .day, value: 0, to: Date())!,
         picture: "https://mblogthumb-phinf.pstatic.net/MjAyMjAyMDdfMjEy/MDAxNjQ0MTk0Mzk2MzY3.WAeeVCu2V3vqEz_9[…]0aKX8B1w2oKQg.JPEG.41minit/1643900851960.jpg?type=w800",
         petName: "pet1",
         description: "description1",
         kind: "dog"),
    
    
    Lost(lostIdentifier: "lost2",
         latitude: 37.316694,
         longitude: 126.829903,
         user: User.dummyUser[1],
         title: "title2",
         postDate: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
         lostDate: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
         picture: "https://mblogthumb-phinf.pstatic.net/MjAyMTEyMjJfNDcg/MDAxNjQwMTUwOTUzODg2.ywMUl6KPyDdljDTu[…]DPvsie3hsrzog.JPEG.41minit/1640142789090.jpg?type=w800",
         petName: "pet2",
         description: "description2",
         kind: "dog"),
    
    Lost(lostIdentifier: "lost3",
         latitude: 37.316703,
         longitude: 126.830925,
         user: User.dummyUser[2],
         title: "title3",
         postDate: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
         lostDate: Calendar.current.date(byAdding: .day, value: -2, to: Date())!,
         picture: "https://mblogthumb-phinf.pstatic.net/MjAyMTAxMjZfMTUw/MDAxNjExNjM3NTgwMTE5.op7Uxlhw2azjEKH3[…]tndCaC0g.JPEG.yoonsu3454/20201231_115330.jpg?type=w800",
         petName: "pet3",
         description: "description3",
         kind: "dog"),
    
    Lost(lostIdentifier: "lost4",
         latitude: 37.317363,
         longitude: 126.830993,
         user: User.dummyUser[3],
         title: "title4",
         postDate: Calendar.current.date(byAdding: .day, value: -3, to: Date())!,
         lostDate: Calendar.current.date(byAdding: .day, value: -3, to: Date())!,
         picture: "https://cdn.salgoonews.com/news/photo/202105/2904_7323_220.jpg",
         petName: "pet4",
         description: "description4",
         kind: "dog"),
  
    Lost(lostIdentifier: "lost5",
         latitude: 37.317010,
         longitude: 126.830442,
         user: User.dummyUser[4],
         title: "title5",
         postDate: Calendar.current.date(byAdding: .day, value: -4, to: Date())!,
         lostDate: Calendar.current.date(byAdding: .day, value: -4, to: Date())!,
         picture: "https://www.fitpetmall.com/wp-content/uploads/2023/02/CK_tc02730000546-edited-scaled.jpg",
         petName: "pet5",
         description: "description5",
         kind: "dog")
    ]
}

struct Comment {
    var user: User
    var description: String
    let date: Date
    
    static var dummyComment: [Comment] = [
        Comment(user: User.dummyUser[0], description: "description1", date: Calendar.current.date(byAdding: .day, value: 0, to: Date())!),
        Comment(user: User.dummyUser[1], description: "description2", date: Calendar.current.date(byAdding: .day, value: -1, to: Date())!),
        Comment(user: User.dummyUser[2], description: "description3", date: Calendar.current.date(byAdding: .day, value: -2, to: Date())!),
        Comment(user: User.dummyUser[3], description: "description4", date: Calendar.current.date(byAdding: .day, value: -3, to: Date())!),
        Comment(user: User.dummyUser[4], description: "description5", date: Calendar.current.date(byAdding: .day, value: -4, to: Date())!),
    ]
}
