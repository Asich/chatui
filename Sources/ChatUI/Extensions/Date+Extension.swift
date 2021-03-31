//
//  File.swift
//  
//
//  Created by User on 02.03.2021.
//

import Foundation

extension Date {
    func isInSameDayAndTimeOf(date: Date) -> Bool {
        return Calendar.current.isDate(self, equalTo: date, toGranularity: .minute)
    }
}
