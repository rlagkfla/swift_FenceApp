//
//  Date+Ext.swift
//  FenceApp
//
//  Created by JeonSangHyeok on 11/2/23.
//

import Foundation

extension Date {
    func getConverDate(lostTime: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 MM월 dd일 HH시 mm분"
        
        let converDate = formatter.string(from: lostTime)
        
        return converDate
    }
}
