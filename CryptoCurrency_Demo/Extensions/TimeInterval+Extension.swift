//
//  TimeInterval+Extension.swift
//  EquityGroupTest_TusharZade
//
//  Created by Tushar Zade on 04/03/25.
//

import Foundation

extension TimeInterval {
    func formattedDate(format: String = "MMM d, yyyy", locale: Locale = .current) -> String {
        let date = Date(timeIntervalSince1970: self)
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = locale
        return formatter.string(from: date)
    }
}
