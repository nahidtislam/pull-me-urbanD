//
//  Date+InitFromString.swift
//  invoicer
//
//  Created by Nahid Islam on 15/12/2021.
//

import Foundation

extension Date {
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
