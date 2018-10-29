//
//  StringExtension.swift
//  CommandLineScope
//
//  Created by 전병학 on 23/10/2018.
//  Copyright © 2018 전병학. All rights reserved.
//

import Foundation

extension String {
    func toDouble()->Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
    
    func toInteger()->Int? {
        return NumberFormatter().number(from: self)?.intValue
    }
    
    func trim() -> String
    {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
}
