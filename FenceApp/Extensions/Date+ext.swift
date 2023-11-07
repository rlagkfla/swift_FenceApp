//
//  Date+ext.swift
//  FenceApp
//
//  Created by Woojun Lee on 11/5/23.
//

import Foundation

extension Date {
    
    func startOfTheDay() -> Date {
        
        let currentCalendar = Calendar.current
        
        return currentCalendar.startOfDay(for: Date())
    }
    
    func endOfTheDay() -> Date {
        
        let currentCalendar = Calendar.current
        
        return currentCalendar.startOfDay(for: currentCalendar.date(byAdding: .day, value: 1, to: self) ?? Date())
    }
    
    func dateToString() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 MM월 dd일 HH시 mm분"
        let converDate = formatter.string(from: self)
        
        return converDate
    }
}
