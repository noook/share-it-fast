//
//  DictionaryExtension.swift
//  Share It Fast
//
//  Created by Neil Richter on 25/11/2019.
//  Copyright © 2019 Neil Richter. All rights reserved.
//

import Foundation

extension Dictionary {
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}
