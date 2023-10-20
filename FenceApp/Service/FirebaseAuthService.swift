//
//  FirebaseAuthService.swift
//  FenceApp
//
//  Created by Woojun Lee on 10/18/23.
//

import Foundation
import FirebaseAuth

struct FirebaseAuthService {
    
    func signUpUser(email: String, password: String) async throws -> AuthDataResult {
        let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
        
        return authResult
        
    }

}
