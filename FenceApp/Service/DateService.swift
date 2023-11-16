//
//  DateService.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 11/3/23.
//

import Foundation

struct DateService {
    func converToDateInFilterLabel(fromDate: Date, toDate: Date) -> String {
        let result = toDate.timeIntervalSince1970 - fromDate.timeIntervalSince1970
        
        switch result {
        case ...86400:
            return "1"
        case 86400...:
            return "\(Int(result / 86400))"
        default:
            return "알 수 없는 오류"
        }
    }
}
