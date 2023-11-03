//
//  Date+Ext.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 11/2/23.
//

import Foundation

extension Date {
    func convertToDate(lostTime: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 MM월 dd일 HH시 mm분"
        
        let convertToDate = formatter.string(from: lostTime)
        
        return convertToDate
    }
    
    func converToDateInFilterLabel(fromDate: Date, toDate: Date) -> String {
        let result = toDate.timeIntervalSince1970 - fromDate.timeIntervalSince1970
        
        switch result {
        case 86400...:
            return "\(Int(result / 86400))일 이내"
        default:
            return "알 수 없는 오류"
        }
    }
}
