import Foundation
import FirebaseFirestore

class MessageViewModel {

    var messages: [Message] = []
    var chatRoomId: String //Current User ID
    var senderUserIdentifier: String

    init(chatRoomId: String, senderUserIdentifier: String) {
        self.chatRoomId = chatRoomId
        self.senderUserIdentifier = senderUserIdentifier
    }
    
    func sendMessage(_ message: Message) {
        addMessageToFirestore(message)
        updateChatRoomInFirestore(message)
        sendPushNotification(message.content)
        messages.append(message)
    }

    private func addMessageToFirestore(_ message: Message) {
        let db = Firestore.firestore()

        let messageData: [String: Any] = [
            "senderId": senderUserIdentifier,
            "recipientId": CurrentUserInfo.shared.currentUser?.userIdentifier,
            "content": message.content,
            "timestamp": Timestamp(date: Date()),
        ]

        db.collection("chat_list").document(chatRoomId).collection("messages").addDocument(data: messageData) { error in
            if let error = error {
                print("Error adding message: \(error)")
            } else {
                print("Message successfully added to Firestore")
            }
        }
    }

    private func updateChatRoomInFirestore(_ message: Message) {
        let db = Firestore.firestore()
        let chatRoomData: [String: Any] = [
            "lastMessage": message.content,
            "timestamp": Timestamp(date: Date()),
            // other chat room-related fields
        ]

        db.collection("chat_list").document(chatRoomId).updateData(chatRoomData) { error in
            if let error = error {
                print("Error updating chat room: \(error)")
            } else {
                print("Chat room successfully updated!")
            }
        }
    }

    private func sendPushNotification(_ messageContent: String) {
        // Implement push notification logic here
    }
}
