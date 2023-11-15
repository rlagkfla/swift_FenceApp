
import Foundation
import RxSwift
import FirebaseFirestore

class ChatRoomsViewModel {
    
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    let chatRooms: BehaviorSubject<[ChatRoom]> = BehaviorSubject(value: [])
    
}

extension ChatRoomsViewModel {
    
    // MARK: - Methods
    func loadChatRooms() {
        let db = Firestore.firestore()
        db.collection("chat_list")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { [weak self] (querySnapshot, error) in
                if let error = error {
                    print("Error getting chat rooms: \(error)")
                    AlertHandler.shared.presentErrorAlert(for: .networkError("네트워크 연결상태를 확인해주세요"))
                    return
                }
                
                guard let documents = querySnapshot?.documents else {
                    print("No documents in chat_list")
                    return
                }

                let rooms = documents.compactMap { document -> ChatRoom? in
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
                    
                    return ChatRoom(
                        lastMessage: lastMessage,
                        profileImageURL: profileImageURL,
                        timestamp: timestamp,
                        userNickName: userNickName
                    )
                }
                
                DispatchQueue.main.async {
                    self?.chatRooms.onNext(rooms)
                }
            }
    }


}
