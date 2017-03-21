//
//  PersistenceLayer.swift
//  ViewModelTestingDemo
//
//  Created by Bryan Weber on 11/9/16.
//  Copyright © 2016 Bryan Weber. All rights reserved.
//

import Foundation

protocol PersistenceLayer {
    func set(_ value: Bool, forKey defaultName: String)
    func bool(forKey defaultName: String) -> Bool
}

extension UserDefaults: PersistenceLayer {}
