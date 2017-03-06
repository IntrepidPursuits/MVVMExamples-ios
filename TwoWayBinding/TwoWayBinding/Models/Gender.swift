//
//  Gender.swift
//  TwoWayBinding
//
//  Created by Benjamin Wu on 3/6/17.
//  Copyright © 2017 Intrepid Pursuits. All rights reserved.
//

import Foundation

enum Gender: Int {
    case female = 0
    case male
    case other

    var displayText: String {
        switch self {
        case .female:
            return "Female"
        case .male:
            return "Male"
        case .other:
            return "Other"
        }
    }
}
