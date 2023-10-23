//
//  Date+InitFromString.swift
//  invoicer
//
//  Created by Nahid Islam on 15/12/2021.
//

import Foundation

extension Date {
    /// Create a date converted from a string based on a format
    /// - Parameters:
    ///   - stringValue: the value to convert from
    ///   - format: the format to convert the value from. The default is `yyyy-MM-dd HH:mm:ss Z` as printing a date value is in that format
    init?(_ stringValue: String,
          withFormat format: String = "yyyy-MM-dd HH:mm:ss Z") {
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_GB_POSIX")
        formatter.dateFormat = format
        
        if let date = formatter.date(from: stringValue) {
            self = date
        } else {
            return nil
        }
    }
}
