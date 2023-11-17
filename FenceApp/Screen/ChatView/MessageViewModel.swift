import Foundation
import FirebaseFirestore


class MessageViewModel {

    var messages: [Message] = []
    var lost: Lost
    var currentUser: CurrentUserInfo

    init(lost: Lost, currentUser: CurrentUserInfo) {
        self.lost = lost
        self.currentUser = currentUser
    }
    
    func sendMessage(_ message: Message) {
        addMessageToFirestore(message)
        updateChatRoomInFirestore(message)
        sendPushNotification(message.content)
        messages.append(message)
    }

    private func addMessageToFirestore(_ message: Message) {
        let db = Firestore.firestore()

        let timestamp = Timestamp(date: Date())
        let lostUserIdentifier = lost.userIdentifier

        let chatMessageData: [String: Any] = [
            "currentUserImageURL": currentUser.currentUser?.profileImageURL,
            "currentUserText": message.content,
            "lostUserImageURL": lost.userProfileImageURL,
            "lostUserNickName": lost.userNickName,
            "lostUserProfileImageURL": lost.userProfileImageURL,
            "lostUserText": message.content,
            "timestamp": timestamp
        ]

        db.collection("chat_message").document(lostUserIdentifier).collection("messages").addDocument(data: chatMessageData) { error in
            if let error = error {
                print("Error adding message to chat_message: \(error)")
            } else {
                print("Message successfully added to chat_message")
            }
        }

        let chatListData: [String: Any] = [
            "lastMessage": message.content,
            "profileImageURL": currentUser.currentUser?.profileImageURL,
            "timestamp": timestamp,
            "userIdentifier": currentUser.currentUser?.userIdentifier,
            "userNickName": currentUser.currentUser?.nickname
        ]

        db.collection("chat_list").document(lostUserIdentifier).updateData(chatListData) { error in
            if let error = error {
                print("Error updating chat_list: \(error)")
            } else {
                print("Chat list successfully updated!")
            }
        }
        updateChatRoomInFirestore(message)
    }

    private func updateChatRoomInFirestore(_ message: Message) {
        let db = Firestore.firestore()
        let lostUserIdentifier = lost.userIdentifier
        let chatRoomData: [String: Any] = [
            "lastMessage": message.content,
            "timestamp": Timestamp(date: Date()),
        ]
        db.collection("chat_list").document(lostUserIdentifier).updateData(chatRoomData) { error in
            if let error = error {
                print("Error updating chat room: \(error)")
            } else {
                print("Chat room successfully updated!")
            }
        }
    }

    private func sendPushNotification(_ messageContent: String) {
     
    }
}
