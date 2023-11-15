
import Foundation

struct MessageRoom {
    let lastMessage: String
    let profileImageURL: String
    let timestamp: Date
    let userNickName: String
}

struct Message {
    
    
    let userNickName: String
    let text: String
    let timestamp: Date
    let senderFCMToken: String
    
    
}
