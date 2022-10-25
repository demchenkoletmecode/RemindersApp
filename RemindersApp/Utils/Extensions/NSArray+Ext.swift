//
//  NSArray+Ext.swift
//  RemindersApp
//
//  Created by Андрей on 25.10.2022.
//

import Foundation

extension NSArray {
    
    func decode<T>(_ type: T.Type) -> T? where T: Decodable {
        let jsonData = (try? JSONSerialization.data(withJSONObject: self, options: [])) ?? Data()
        return try? JSONDecoder().decode(type, from: jsonData)
    }

    func encode<T>(_ value: T) -> Any? where T: Encodable {
        let jsonData = try? JSONEncoder().encode(value)
        return try? JSONSerialization.jsonObject(with: jsonData ?? Data(), options: .allowFragments)
    }
    
}
