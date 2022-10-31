//
//  NSDictionary+Ext.swift
//  RemindersApp
//
//  Created by Андрей on 25.10.2022.
//

import Foundation

extension NSDictionary {
    
    func decode<T>(_ type: T.Type) -> T? where T: Decodable {
        let jsonData = (try? JSONSerialization.data(withJSONObject: self, options: [])) ?? Data()
        return try? JSONDecoder().decode(type, from: jsonData)
    }

    func encode<T>(_ value: T) -> Any? where T: Encodable {
        let jsonData = try? JSONEncoder().encode(value)
        return try? JSONSerialization.jsonObject(with: jsonData ?? Data(), options: .allowFragments)
    }
    
    func decodeAsArray<T>(_ type: T.Type) throws -> T where T: Decodable {
        let jsonData = try JSONSerialization.data(withJSONObject: self.allValues, options: [])
        return try JSONDecoder().decode(type, from: jsonData)
    }
    
    func decodeContainer<T: Decodable>(_ type: T.Type) throws -> [T] {
        let jsonData = try JSONSerialization.data(withJSONObject: allValues, options: [])
        let container = try JSONDecoder().decode(IdNestingContainer<T>.self, from: jsonData)
        return container.data
    }
    
}
