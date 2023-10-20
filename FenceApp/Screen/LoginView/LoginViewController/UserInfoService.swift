import Foundation
import FirebaseFirestore

class UserInfoService {
    
    let db = Firestore.firestore()
    
    func writeUserInfoToFirestore(email: String, uid: String) {
        
        let userRef = db.collection("users").document(uid)
        let userData: [String: Any] = ["email": email]
        
        userRef.setData(userData) { error in
        guard let error = error else {print("Successfully \(#function)"); return}
        print("Failed to \(#function)")}
    }
    
    func fetchUserEmail(for uid: String) async throws -> String? {
        let userRef = db.collection("users").document(uid)
        let document = try await userRef.getDocument()
        guard let userEmail = document.data()?["email"] as? String else {return nil}
        print("Successfully \(#function)")
        return userEmail
    }
}
