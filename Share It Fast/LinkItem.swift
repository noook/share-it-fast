//
//  LinkItem.swift
//  Share It Fast
//
//  Created by Neil Richter on 25/11/2019.
//  Copyright © 2019 Neil Richter. All rights reserved.
//

import Foundation
import SwiftyJSON

struct LinkItem: Codable {
    let link: String
    let timestamp: Date
    
    init(link: String, timestamp: Date) {
        self.link = link
        self.timestamp = timestamp
    }
    
    static func loadLinks() -> [LinkItem] {
        let links: String = UserDefaults.standard.string(forKey: "links") ?? "[]"
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let decoded: [LinkItem] = try! decoder.decode([LinkItem].self, from: links.data(using: .utf8)!)
        
        return decoded
    }
    
    static func save(elements: [LinkItem]) {
        
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try! encoder.encode(elements)
        let encoded = String(data: data, encoding: .utf8)!
        
        UserDefaults.standard.set(encoded, forKey: "links")
    }
}
