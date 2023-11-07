//
//  FirebaseCloudMessaging.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 11/7/23.
//

import Foundation

enum MessagingError: Error {
    case invalidURL
    case netWorkError
}

struct FirebaseCloudMessaging {
    let serverKey = "AAAAZ4CjZqE:APA91bEW-e0wS7MSHeg2SpcMkQSQzSy0JiK448yYW6ZxnXc1eKkQ4u_jw1t5BV_rDpF0OtMS9aNLz31UaWMthSDXCeem5vpndqN6l_lqN3bxr6pI-hWxIFypAE225of79de-GdSf4hZd"
    let fcmSendUrl = URL(string: "https://fcm.googleapis.com/fcm/send")
    
    func sendCommentMessaing(userToken: String, title: String, comment: String) async throws {
        guard let url = fcmSendUrl else {
            throw MessagingError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("key=\(serverKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let message: [String: Any] = [
            "to": userToken,
            "notification": [
                "title": title,
                "body": comment
            ]
        ]
        
        let jsonData = try JSONSerialization.data(withJSONObject: message)
        request.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { throw MessagingError.netWorkError }
        
        let responseJSON = try JSONSerialization.jsonObject(with: data)
    }
}
