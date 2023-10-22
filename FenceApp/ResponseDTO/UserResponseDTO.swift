//
//  UserDTO.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/19/23.
//

struct UserResponseDTO {
    
    let email: String
    var profileImageURL: String
    let identifier: String
    var nickname: String
    
    static var dummyUser: [UserResponseDTO] = [
        UserResponseDTO(email: "aaa@gmail.com",profileImageURL: "https://i.namu.wiki/i/Qi6-ujIIuSfOQ5sh06m9T8umR8lLf_ryzzS9f7qmat0Npe9KLXSDxvovYGjj[…]gcqn9mgD0cUumJ27NyAf9hEiFBCSKgpjLh3p-Okl8Mn413VsGz-dodb6gA.webp", identifier: "user1", nickname: "user1"),
        UserResponseDTO(email: "bbb@gmail.com",profileImageURL: "https://i.namu.wiki/i/XGKcLALgTFEOwBFIC1PXIfjab1EKO53yGBXhKMEPeDQItwXjtZzCNUoijH4G[…]gbjhV9HTWN9j2-PZ6kB5Ap-UyB2m2gD_tlaYu7ImuiDJMeIywBeeEMl8Kw.webp", identifier: "user2", nickname: "user2"),
        UserResponseDTO(email: "ccc@gmail.com",profileImageURL: "https://i.namu.wiki/i/-5LMNb2M9lxLETGtKKHa6Nv1NfEiAvHMz38rb7dyZQCkcoqHsthPAYucW0jC[…]7ZNcaBdEiwgrg0NpFP5EXThsf31tIkc7d8gKaaDer8n7mo0NBfN9PpY_gw.webp", identifier: "user3", nickname: "user3"),
        UserResponseDTO(email: "ddd@gmail.com",profileImageURL: "https://i.namu.wiki/i/buRp-Z6r8egBOFmmqtsepfzhZaWGsPUiL5Tk30YJ-Pql1V2KwrGrLx51nOU5[…]PP3BzgZbXwni5AwlKtsQBk0mggfd9Q4F4qSBEGs9kEqAKgw-gS-QzzfXCw.webp", identifier: "user4", nickname: "user4"),
        UserResponseDTO(email: "eee@gmail.com",profileImageURL: "https://i.namu.wiki/i/jo4uFuxhDeR8EQWONfp3eJNuU80L918RS_3q2kDpT8mGbesLBYG1Fyj3Zw3O[…]jTeG_3Lr5oO13j6UC6JkBS18PLrxSJL4-PntO3iQ6kVwEgjqXUzIzJoSRA.webp", identifier: "user5", nickname: "user5"),
    ]
}
