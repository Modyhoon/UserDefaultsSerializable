//
//  UserDefaultsSerializable+PropertyList.swift
//  UserDefaultsSerializable
//
//  Created by mody on 4/17/25.
//

import Foundation

/// https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/PropertyLists/AboutPropertyLists/AboutPropertyLists.html#//apple_ref/doc/uid/10000048i-CH3-54303
internal protocol PropertyListType {
    static func getValue(userDefaults: UserDefaultsProtocol, key: String) throws (PropertyListAccessError) -> PropertyListType
    func setValue(userDefaults: UserDefaultsProtocol, key: String)
}

extension PropertyListType {
    func setValue(userDefaults: UserDefaultsProtocol, key: String) {
        userDefaults.set(self, forKey: key)
    }
}

extension Int: PropertyListType {
    internal static func getValue(userDefaults: UserDefaultsProtocol, key: String) throws (PropertyListAccessError) -> any PropertyListType {
        userDefaults.integer(forKey: key)
    }
}

extension Float: PropertyListType {
    internal static func getValue(userDefaults: UserDefaultsProtocol, key: String) throws (PropertyListAccessError) -> any PropertyListType {
        userDefaults.float(forKey: key)
    }
}

extension Double: PropertyListType {
    internal static func getValue(userDefaults: UserDefaultsProtocol, key: String) throws (PropertyListAccessError) -> any PropertyListType {
        userDefaults.double(forKey: key)
    }
}

extension Bool: PropertyListType {
    internal static func getValue(userDefaults: UserDefaultsProtocol, key: String) throws (PropertyListAccessError) -> any PropertyListType {
        userDefaults.bool(forKey: key)
    }
}

extension String: PropertyListType {
    internal static func getValue(userDefaults: UserDefaultsProtocol, key: String) throws (PropertyListAccessError) -> any PropertyListType {
        if let string = userDefaults.string(forKey: key) {
            return string
        } else {
            throw .notFound
        }
    }
}

extension Data: PropertyListType {
    internal static func getValue(userDefaults: UserDefaultsProtocol, key: String) throws (PropertyListAccessError) -> any PropertyListType {
        if let data = userDefaults.data(forKey: key) {
            return data
        } else {
            throw .notFound
        }
    }
}

extension Date: PropertyListType {
    internal static func getValue(userDefaults: UserDefaultsProtocol, key: String) throws (PropertyListAccessError) -> any PropertyListType {
        if let date = userDefaults.object(forKey: key) as? Self {
            return date
        } else {
            throw .notFound
        }
    }
}

extension Array: PropertyListType where Element: PropertyListType {
    internal static func getValue(userDefaults: UserDefaultsProtocol, key: String) throws (PropertyListAccessError) -> any PropertyListType {
        if let array = userDefaults.array(forKey: key) as? Self {
            return array
        } else {
            throw .notFound
        }
    }
}

extension Dictionary: PropertyListType where Key == String, Value: PropertyListType {
    internal static func getValue(userDefaults: UserDefaultsProtocol, key: String) throws (PropertyListAccessError) -> any PropertyListType {
        if let dictionary = userDefaults.dictionary(forKey: key) as? Self {
            return dictionary
        } else {
            throw .notFound
        }
    }
}

enum PropertyListAccessError: Error {
    case notFound
}
