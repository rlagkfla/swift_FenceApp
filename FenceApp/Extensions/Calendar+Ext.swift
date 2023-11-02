//
//  Calendar.swift
//  FenceApp
//
//  Created by Woojun Lee on 11/2/23.
//

import Foundation

extension Calendar {
    
    static let today = Calendar.current.date(byAdding: .day, value: 0, to: Date())!
    static let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
    
}
