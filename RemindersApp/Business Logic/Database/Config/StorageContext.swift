//
//  StorageContext.swift
//  RemindersApp
//
//  Created by Андрей on 11.11.2022.
//

import Foundation

protocol StorageContext {
    
    associatedtype T

    func save(object: T) -> Error?
    func query(predicate: NSPredicate?) -> Result<[T], Error>
    func delete(object: T) -> Error?
    
}
