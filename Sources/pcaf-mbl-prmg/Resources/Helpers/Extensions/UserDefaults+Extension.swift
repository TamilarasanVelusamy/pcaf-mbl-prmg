//
//  UserDefaults+Extension.swift
//  SalesProPlus
//
//  Created by ketan on 15/11/22.
//

import Foundation

protocol ObjectSavable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable
    func saveObjectForKey<T:Encodable>(_ key:String,_ obj:T) 
}

enum ObjectSavableError: String, LocalizedError {
    case unableToEncode = "Unable to encode object into data"
    case noValue = "No data object found for the given key"
    case unableToDecode = "Unable to decode object into given type"
    
    var errorDescription: String? {
        rawValue
    }
}

extension UserDefaults: ObjectSavable {
    /// Save custom objects in User Defaults
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(object)
            set(data, forKey: forKey)
        } catch {
            throw ObjectSavableError.unableToEncode
        }
    }
    
    /// Get custom object from User Defaults
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable {
        guard let data = data(forKey: forKey) else { throw ObjectSavableError.noValue }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            throw ObjectSavableError.unableToDecode
        }
    }
    func saveObjectForKey<T:Encodable>(_ key:String,_ obj:T) {
        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()
            let encodedObj = try encoder.encode(obj)
            UserDefaults.standard.set(encodedObj, forKey: key)
        } catch let error{
            PMLog.shared.logger?.log(.verbose, message: "PM UserDefaults :\(error)")
        }
    }
}
