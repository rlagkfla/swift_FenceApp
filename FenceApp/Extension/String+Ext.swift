//
//  String+Ext.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 10/26/23.
//

import Foundation

extension String {
    func getHowLongAgo() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        formatter.locale = Locale(identifier: "ko_KR")
        
        guard let publishedDate = formatter.date(from: self) else {
            return "날짜 파싱 오류: \(self)" }
        
        let result = Date().timeIntervalSince1970 - publishedDate.timeIntervalSince1970
        
        switch result {
        case ..<60:
            return "방금"
        case 60..<3600:
            return "\(Int(result / 60))분 전"
        case 3600..<86400:
            return "\(Int(result / 3600))시간 전"
        case 86400...:
            return "\(Int(result / 86400))일 전"
        default:
            return "알 수 없는 오류"
        }
    }
}
