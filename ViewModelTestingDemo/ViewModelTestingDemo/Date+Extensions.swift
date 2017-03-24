//
//  Date+Extensions.swift
//  ViewModelTestingDemo
//
//  Created by Bryan Weber on 11/3/16.
//  Copyright © 2016 Bryan Weber. All rights reserved.
//

import Foundation

extension Date {
    
    init?(dateString: String) {
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"        
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale!
        
        guard let date = dateStringFormatter.date(from: dateString) else { return nil }
        self.init(timeInterval:0, since:date)
    }
}
