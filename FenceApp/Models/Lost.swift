//
//  Lost.swift
//  FenceApp
//
//  Created by Woojun Lee on 11/2/23.
//

import Foundation

struct Lost: Pinable {
    
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
}
