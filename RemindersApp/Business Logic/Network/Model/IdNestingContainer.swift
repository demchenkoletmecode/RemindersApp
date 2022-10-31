//
//  IdNestingContainer.swift
//  RemindersApp
//
//  Created by Андрей on 31.10.2022.
//

import Foundation

struct IdNestingContainer<T: Decodable>: Decodable {
    
    let data: [T]
    
    private struct CustomCodingKeys: CodingKey {
        
        var stringValue: String
        var intValue: Int?
        
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        
        init?(intValue: Int) {
            return nil
        }
        
    }
    
    enum CodingKeys: CodingKey {
        case data
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CustomCodingKeys.self)
        
        var data = [T]()
        for key in container.allKeys {
            let element = try container.decode(T.self, forKey: key)
            data.append(element)
        }
        self.data = data
    }
    
}
