import Foundation
import MessageKit
import UIKit

class Message: MessageType {
    let id: String?
    var messageId: String {
        return id ?? UUID().uuidString
    }
    let content: String
    let sentDate: Date
    let sender: SenderType // Represents the sender of the message
    var kind: MessageKind {
        if let image = image {
            let mediaItem = ImageMediaItem(image: image)
            return .photo(mediaItem)
        } else {
            return .text(content)
        }
    }
    
    var image: UIImage?
    var downloadURL: URL?

    // Use this initializer for text messages
    init(content: String) {
        // Assuming CurrentUserInfo.shared.currentUser contains the current user's details
        if let currentUser = CurrentUserInfo.shared.currentUser {
            self.sender = Sender(senderId: currentUser.userIdentifier, displayName: currentUser.nickname)
        } else {
            // Fallback sender details if current user is not available
            self.sender = Sender(senderId: "unknown", displayName: "Unknown")
        }
        self.content = content
        self.sentDate = Date()
        self.id = nil
    }

    init(image: UIImage) {
        if let currentUser = CurrentUserInfo.shared.currentUser {
            self.sender = Sender(senderId: currentUser.userIdentifier, displayName: currentUser.nickname)
        } else {
            self.sender = Sender(senderId: "unknown", displayName: "Unknown")
        }
        self.image = image
        self.sentDate = Date()
        self.content = ""
        self.id = nil
    }
}

extension Message: Comparable {
    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id
    }

    static func < (lhs: Message, rhs: Message) -> Bool {
        return lhs.sentDate < rhs.sentDate
    }
}
