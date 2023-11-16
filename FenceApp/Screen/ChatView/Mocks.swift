//
//  Mocks.swift
//  FenceApp
//
//  Created by t2023-m0067 on 11/15/23.
//

import Foundation

//func getChannelMocks() -> [Channel] {
//    return (0...3).map { Channel(id: String($0), name: "name " + String($0)) }
//}

func getMessagesMock() -> [Message] {
    return (0...3).map { Message(content: "message content \($0)") }
}
