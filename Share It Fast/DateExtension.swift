//
//  DateExtension.swift
//  Share It Fast
//
//  Created by Neil Richter on 25/11/2019.
//  Copyright © 2019 Neil Richter. All rights reserved.
//

import Foundation

extension Date {
    func toString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
