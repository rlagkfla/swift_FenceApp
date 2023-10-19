
import Foundation
import FirebaseFirestore

class UserInfoService {
    func writeUserInfoToFirestore(email: String, uid: String) {
        
        let db = Firestore.firestore()
        
        let userRef = db.collection("users").document(uid)
        
        let userData: [String: Any] = [
            "email": email,
        ]
        
        userRef.setData(userData) { error in
            if let error = error {
                print("Error writing user data to Firestore: \(error)")
            } else {
                print("User data successfully written to Firestore")
            }
        }
    }
}
