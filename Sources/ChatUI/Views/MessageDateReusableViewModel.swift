//
//  MessageDateReusableViewModel.swift
//  MyBeeline
//
//  Created by admin on 11/13/20.
//  Copyright © 2020 Veon LTD. All rights reserved.
//

import Foundation

struct MessageDateReusableViewModel {
    var dateText: String {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        if calendar.isDateInToday(date) {
            formatter.dateFormat = "HH:mm"
            return (localizedText?.today ?? "Today") + ", " + formatter.string(from: date)
        } else if calendar.isDateInYesterday(date) {
            formatter.dateFormat = "HH:mm"
            return (localizedText?.yesterday ?? "Yesterday") + ", " + formatter.string(from: date)
        } else {
            let startOfNow = calendar.startOfDay(for: Date())
            let startOfTimeStamp = calendar.startOfDay(for: date)
            let components = calendar.dateComponents([.year], from: startOfNow, to: startOfTimeStamp)
            let year = components.year!
            if year >= 0 {
                formatter.dateFormat = "d MMMM, HH:mm"
                return formatter.string(from: date)
            } else {
                formatter.dateFormat = "d MMMM yyyy, HH:mm"
                return formatter.string(from: date)
            }
        }
    }
    
    private var date: Date
    private var localizedText: DateLabel?
    
    init(date: Date, localizedText: DateLabel?) {
        self.date = date
        self.localizedText = localizedText
    }
}
