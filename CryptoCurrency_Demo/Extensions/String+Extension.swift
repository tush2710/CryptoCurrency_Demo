//
//  String+Extension.swift
//  EquityGroupTest_TusharZade
//
//  Created by Tushar Zade on 04/03/25.
//

import Foundation

extension String {
    
    /// Formats a string representing a price to a human-readable currency format
    func formattedAsCurrency(locale: Locale = .current) -> String? {
        guard let number = Double(self) else { return nil }
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = locale
        return formatter.string(from: NSNumber(value: number))
    }
    
    /// Converts a date string from a given format to a more readable format
    func formattedDate(from inputFormat: String, to outputFormat: String = "MMM d, yyyy") -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputFormat
        dateFormatter.locale = Locale.current
        guard let date = dateFormatter.date(from: self) else { return nil }
        dateFormatter.dateFormat = outputFormat
        return dateFormatter.string(from: date)
    }
}
