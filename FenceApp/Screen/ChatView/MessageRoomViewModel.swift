import Foundation
import RxSwift
import FirebaseFirestore



// MARK: - Initialization
class MessageRoomViewModel {
    
    
    private let disposeBag = DisposeBag()
    private var listenerRegistration: ListenerRegistration?
    let messageRooms = BehaviorSubject<[MessageRoom]>(value: [])
    
    

    deinit {
        stopListening()
    }
}



// MARK: - Firestore Data Loading
extension MessageRoomViewModel {
    
    func loadChatRooms() {
        guard let userIdentifier = CurrentUserInfo.shared.currentUser?.userIdentifier else {
            print("User identifier is nil")
            return
        }

        let db = Firestore.firestore()
        listenerRegistration = db.collection("chat_list").document(userIdentifier)
            .addSnapshotListener { [weak self] (documentSnapshot, error) in
                if let error = error {
                    print("Error getting chat rooms: \(error)")
                    return
                }

                guard let document = documentSnapshot else {
                    print("DocumentSnapshot is nil")
                    return
                }

                if !document.exists {
                    print("Document does not exist")
                    return
                }

                let data = document.data()
                print("Document data: \(String(describing: data))")

                if let lastMessage = data?["lastMessage"] as? String,
                   let profileImageURL = data?["profileImageURL"] as? String,
                   let timestamp = (data?["timestamp"] as? Timestamp)?.dateValue(),
                   let userNickName = data?["userNickName"] as? String,
                   let userIdentifier = data?["userIdentifier"] as? String {
                    
                    let messageRoom = MessageRoom(lastMessage: lastMessage,
                                                  profileImageURL: profileImageURL,
                                                  timestamp: timestamp,
                                                  userNickName: userNickName,
                                                  userIdentifier: userIdentifier)
                    self?.messageRooms.onNext([messageRoom])
                } else {
                    print("Error parsing document data")
                }
            }
    }

}


//MARK: - Helper
extension MessageRoomViewModel {


    private func createMessageRoom(from data: [String: Any]) -> MessageRoom? {
        guard
            let lastMessage = data["lastMessage"] as? String,
            let profileImageURL = data["profileImageURL"] as? String,
            let timestamp = (data["timestamp"] as? Timestamp)?.dateValue(),
            let userNickName = data["userNickName"] as? String,
            let userIdentifier = data["userIdentifier"] as? String
        else {
            print("Error mapping document to ChatRoom")
            return nil
        }
        
        return MessageRoom(
            lastMessage: lastMessage,
            profileImageURL: profileImageURL,
            timestamp: timestamp,
            userNickName: userNickName,
            userIdentifier: userIdentifier
        )
    }
    func stopListening() {
        listenerRegistration?.remove()
    }
}
