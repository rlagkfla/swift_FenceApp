//
//  Message.swift
//  FenceApp
//
//  Created by t2023-m0067 on 11/15/23.
//
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
    let sender: SenderType
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
    
    init(content: String) {
        sender = Sender(senderId: "id(TODO...)", displayName: "rimkim")
        self.content = content
        sentDate = Date()
        id = nil
    }
    
    init(image: UIImage) {
        sender = Sender(senderId: "id(TODO...)", displayName: "rimkim")
        self.image = image
        sentDate = Date()
        content = ""
        id = nil
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
