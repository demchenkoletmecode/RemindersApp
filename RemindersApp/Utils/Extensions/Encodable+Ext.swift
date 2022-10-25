//
//  Encodable+Ext.swift
//  RemindersApp
//
//  Created by Андрей on 25.10.2022.
//

import Foundation

extension Encodable {
    
    var dictionary: [String: Any]? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        return (try? JSONSerialization.jsonObject(with: data,
                                                  options: .allowFragments))
        .flatMap { $0 as? [String: Any] }
    }
    
    var array: [Any]? {
        let jsonData = try? JSONEncoder().encode(self)
        return try? JSONSerialization.jsonObject(with: jsonData ?? Data(), options: .allowFragments) as? [Any]
    }
    
}
