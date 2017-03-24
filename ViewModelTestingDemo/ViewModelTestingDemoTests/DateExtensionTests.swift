//
//  DateExtensionTests.swift
//  ViewModelTestingDemo
//
//  Created by Bryan Weber on 11/3/16.
//  Copyright © 2016 Bryan Weber. All rights reserved.
//

import XCTest
@testable import ViewModelTestingDemo

class DateExtensionTests: XCTestCase {
    
    func testValidStringInit() {
        
        let date = Date(dateString: "2016-10-07T07:00:00Z")
        let calendar = Calendar(identifier: .gregorian)
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date!)
        
        XCTAssertEqual(dateComponents.year, 2016)
        XCTAssertEqual(dateComponents.month, 10)
        XCTAssertEqual(dateComponents.day, 7)
    }
    
    func testInvalidStringInit() {
        let date = Date(dateString: "10-07T07:00:00Z")
        XCTAssertNil(date)
    }
}
