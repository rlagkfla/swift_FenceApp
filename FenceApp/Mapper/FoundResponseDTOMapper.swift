//
//  FoundResponseDTOMapper.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/21/23.
//

import FirebaseFirestore

struct FoundResponseDTOMapper {
    
    static func makeFoundResponseDTOs(dictionary: [String: Any]) -> FoundResponseDTO {
        
        FoundResponseDTO(latitude: dictionary[FB.Found.latitude] as? Double ?? 0,
                         longitude: dictionary[FB.Found.longitude] as? Double ?? 0,
                         imageURL: dictionary[FB.Found.imageURL] as? String ?? "",
                         date: (dictionary[FB.Found.date] as? Timestamp)?.dateValue() ?? Date(),
                         userIdentifier: dictionary[FB.Found.userIdentifier] as? String ?? "",
                         foundIdentifier: dictionary[FB.Found.foundIdentifier] as? String ?? "",
                         userProfileImageURL: dictionary[FB.Found.userProfileImageURL] as? String ?? "",
                         userNickname: dictionary[FB.Found.userNickname] as? String ?? ""
                        
        )
    }
    
    static func makeFoundResponseDTOs(dictionaries: [[String: Any]]) -> [FoundResponseDTO] {
        
        return dictionaries.map { dictionary in
            makeFoundResponseDTOs(dictionary: dictionary)
        }
    }
    
    static func makeDictionary(foundResponseDTO: FoundResponseDTO) -> [String: Any] {
        
        let data: [String: Any] = [FB.Found.latitude: foundResponseDTO.latitude,
                                   FB.Found.longitude: foundResponseDTO.longitude,
                                   FB.Found.imageURL: foundResponseDTO.imageURL,
                                   FB.Found.date: foundResponseDTO.date,
                                   FB.Found.userIdentifier: foundResponseDTO.userIdentifier,
                                   FB.Found.foundIdentifier: foundResponseDTO.foundIdentifier,
                                   FB.Found.userProfileImageURL: foundResponseDTO.userProfileImageURL,
                                   FB.Found.userNickname: foundResponseDTO.userNickname
        ]
        
        return data
    }
    
    static func makeFound(from foundResponseDTO: FoundResponseDTO) -> Found {
        
        Found(latitude: foundResponseDTO.latitude,
              longitude: foundResponseDTO.longitude,
              imageURL: foundResponseDTO.imageURL,
              date: foundResponseDTO.date,
              userIdentifier: foundResponseDTO.userIdentifier,
              foundIdentifier: foundResponseDTO.foundIdentifier,
              userProfileImageURL: foundResponseDTO.userProfileImageURL,
              userNickname: foundResponseDTO.userNickname
        
        )
    }
    
    static func makeFounds(from foundResponseDTOs: [FoundResponseDTO]) -> [Found] {
        
        return foundResponseDTOs.map { makeFound(from: $0)}
    }
}
