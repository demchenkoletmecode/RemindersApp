//
//  FirebaseDatabaseManager.swift
//  RemindersApp
//
//  Created by Андрей on 25.10.2022.
//

import FirebaseDatabase
import Foundation

class FirebaseDatabaseManager {
    
    private let databaseReference: DatabaseReference
    
    init() {
        databaseReference = Database.database().reference()
    }
    
    func readOnce<T: Codable>(from endpoint: FirebaseDatabaseEndpoint,
                              dataType: T.Type,
                              completion: @escaping (Result<T, Error>) -> Void) {
        let query = databaseReference.child(endpoint.path)
        query.keepSynced(endpoint.synced)
        
        query.observeSingleEvent(of: .value,
                                 with: { snapshot in
            do {
                var decodedValue: T?
                if let value = snapshot.value as? NSDictionary {
                    decodedValue = try value.decodeAsArray(T.self)
                    if decodedValue == nil {
                        decodedValue = value.decode(T.self)
                    }
                } else if let value = snapshot.value as? NSArray {
                    decodedValue = value.decode(T.self)
                }
                if let value = decodedValue {
                    completion(.success(value))
                } else {
                    completion(.failure(FirebaseError.decodingError))
                    return
                }
            } catch {
                completion(.failure(error))
            }
        })
    }
             
    func post<T: Codable>(from endpoint: FirebaseDatabaseEndpoint,
                          data: T,
                          createNewKey: Bool = false,
                          completion: @escaping (Result<T, Error>) -> Void) {
        var encodedData: Any?
        if let value = data.dictionary {
            encodedData = value
        }
        if let value = data.array {
            encodedData = value
        }
        if encodedData == nil {
            completion(.failure(FirebaseError.encodingError))
            return
        }
        var reference = databaseReference.child(endpoint.path)
        if createNewKey {
            reference = reference.childByAutoId()
        }
        reference.setValue(encodedData) { error, _ in
            if let error = error {
                completion(.failure(error))
            }
            completion(.success(data))
        }
    }
    
    func remove(from endpoint: FirebaseDatabaseEndpoint,
                completion: @escaping (Result<Void, Error>) -> Void) {
        databaseReference.child(endpoint.path).removeValue { error, _ in
            if let error = error {
                completion(.failure(error))
                return
            }
            completion(.success(()))
        }
    }
    
    func update<T: Codable>(from endpoint: FirebaseDatabaseEndpoint,
                            data: T,
                            completion: @escaping (Result<T, Error>) -> Void) {
        var encodedData: Any?
        if let value = data.dictionary {
            encodedData = value
        }
        if let value = data.array {
            encodedData = value
        }
        if encodedData == nil {
            completion(.failure(FirebaseError.encodingError))
            return
        }
        databaseReference.child(endpoint.path).setValue(encodedData) { error, _ in
            if let error = error {
                completion(.failure(error))
            }
            completion(.success(data))
        }
    }
}
