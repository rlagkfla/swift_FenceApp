import Foundation
import RxSwift
import FirebaseFirestore



// MARK: - Initialization
class MessageRoomViewModel {
    
    
    private let disposeBag = DisposeBag()
    private var listenerRegistration: ListenerRegistration?
    let messageRooms = BehaviorSubject<[MessageRoom]>(value: [])
    
    init() { loadChatRooms() }
    deinit { stopListening() }
}


// MARK: - Firestore Data Loading
extension MessageRoomViewModel {
    
    func loadChatRooms() {
        let db = Firestore.firestore()
        listenerRegistration = db.collection("chat_list")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { [weak self] (querySnapshot, error) in
                
                if let error = error {
                    print("Error getting chat rooms: \(error)")
                    return
                }
                
                let rooms = querySnapshot?.documents.compactMap { self?.createMessageRoom(from: $0) } ?? []
                self?.messageRooms.onNext(rooms)
            }
    }
}


//MARK: - Helper
extension MessageRoomViewModel {

    private func createMessageRoom(from document: QueryDocumentSnapshot) -> MessageRoom? {
        
        let data = document.data()

        guard
            let lastMessage = data["lastMessage"] as? String,
            let profileImageURL = data["profileImageURL"] as? String,
            let timestamp = (data["timestamp"] as? Timestamp)?.dateValue(),
            let userNickName = data["userNickName"] as? String
                
        else {
            print("Error mapping document to ChatRoom")
            return nil
        }
        
        return MessageRoom(
            lastMessage: lastMessage,
            profileImageURL: profileImageURL,
            timestamp: timestamp,
            userNickName: userNickName
        )
    }

    func stopListening() {
        listenerRegistration?.remove()
    }
}
