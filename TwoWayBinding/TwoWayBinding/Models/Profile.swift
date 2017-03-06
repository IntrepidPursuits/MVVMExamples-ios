//
//  Profile.swift
//  TwoWayBinding
//
//  Created by Benjamin Wu on 3/6/17.
//  Copyright © 2017 Intrepid Pursuits. All rights reserved.
//

import Foundation

class Profile {
    var email: String
    var dateOfBirth: Date
    var gender: Gender

    init() {
        email = "donna@summer.com"
        dateOfBirth = Date()
        gender = .female
    }
}
