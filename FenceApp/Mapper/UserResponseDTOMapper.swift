//
//  UserMapper.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/21/23.
//

struct UserResponseDTOMapper {
    
    static func makeUserResponseDTO(from dictionary: [String: Any]) -> UserResponseDTO {
        
        UserResponseDTO(email: dictionary[FB.User.email] as? String ?? "",
                        profileImageURL: dictionary[FB.User.profileImageURL] as? String ?? "",
                        identifier: dictionary[FB.User.useridentifier] as? String ?? "",
                        nickname: dictionary[FB.User.userNickname] as? String ?? "",
                        userFCMToken: dictionary[FB.User.userFCMToken] as? String ?? "")
    }
    
    static func makeUserResponseDTOs(from dictionaries: [[String: Any]]) -> [UserResponseDTO] {
        return dictionaries.map { dictionary in
            makeUserResponseDTO(from: dictionary)
        }
    }
    
    static func makeDictionary(from userResponseDTO: UserResponseDTO) -> [String: Any] {
        
        let data: [String: Any] = [FB.User.email: userResponseDTO.email,
                                   FB.User.userNickname: userResponseDTO.nickname,
                                   FB.User.profileImageURL: userResponseDTO.profileImageURL,
                                   FB.User.useridentifier: userResponseDTO.identifier,
                                   FB.User.userFCMToken: userResponseDTO.userFCMToken]
        
        return data
        
    }
    
    static func makeFBUser(from userResponseDTO: UserResponseDTO) -> FBUser {
        
        return FBUser(email: userResponseDTO.email,
                      profileImageURL: userResponseDTO.profileImageURL,
                      identifier: userResponseDTO.identifier,
                      nickname: userResponseDTO.nickname)
    }
    
    static func makeFBUsers(from userResponseDTOs: [UserResponseDTO]) -> [FBUser] {
        
        userResponseDTOs.map { makeFBUser(from: $0) }
    }
}

