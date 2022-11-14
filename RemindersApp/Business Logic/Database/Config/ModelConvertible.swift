//
//  ModelConvertible.swift
//  RemindersApp
//
//  Created by Андрей on 14.11.2022.
//

import Foundation

protocol ModelCovertible {
    
    associatedtype ModelType
    func toModel() -> ModelType
    
}
