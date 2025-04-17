//
//  UserDefaultsSerializableWrapper.swift
//  UserDefaultsSerializable
//
//  Created by mody on 4/17/25.
//

import Foundation

@propertyWrapper
public struct UserDefaultsSerializable<T: Codable> {
    private let key: String
    private let defaultValue: T
    private let userDefaults: UserDefaultsProtocol

    public init(key: String, defaultValue: T, userDefaults: UserDefaultsProtocol = UserDefaults.standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }

    public var wrappedValue: T {
        get {
            guard userDefaults.object(forKey: key) != nil
            else {
                return defaultValue
            }

            if let optionalBindedValue = getValueWithOptional(T.self) {
                return optionalBindedValue
            }

            if let propertyListType = T.self as? PropertyListType.Type {
                return propertyListValue(propertyListType)
            } else {
                return decoded()
            }
        }

        set {
            let optionalHandled = setValueWithOptional(newValue)
            if optionalHandled {
                return
            }

            if let propertyListValue = newValue as? PropertyListType {
                setPropertyListValue(propertyListValue)
            } else {
                encodeAndSet(newValue)
            }
        }
    }
}

extension UserDefaultsSerializable {
    private func getValueWithOptional(_ type: T.Type) -> T? {
        if let optional = type as? any AnyOptional.Type {
            if let propertyListType = optional.wrappedType.self as? PropertyListType.Type {
                return propertyListValue(propertyListType)
            } else {
                return decoded()
            }
        }

        return nil
    }

    private func setValueWithOptional(_ newValue: T) -> Bool {
        if let optional = newValue as? any AnyOptional {
            let wrappedValue = optional.wrappedValue
            if let propertyListValue = wrappedValue as? PropertyListType {
                setPropertyListValue(propertyListValue)
            } else if wrappedValue == nil {
                userDefaults.removeObject(forKey: key)
            } else {
                encodeAndSet(newValue)
            }

            return true
        }

        return false
    }
}

/// plist 직접 접근
extension UserDefaultsSerializable {
    private func propertyListValue(_ type: PropertyListType.Type) -> T {
        let value = try? type.getValue(userDefaults: userDefaults, key: key) as? T

        guard let value
        else {
            return defaultValue
        }

        return value
    }

    private func setPropertyListValue(_ value: PropertyListType) {
        value.setValue(userDefaults: userDefaults, key: key)
    }
}

/// JSON Serialize
extension UserDefaultsSerializable {
    private func decoded() -> T {
        if let savedData = userDefaults.object(forKey: key) as? Data {
            let decoder = JSONDecoder()
            if let loadedObject = try? decoder.decode(T.self, from: savedData) {
                return loadedObject
            }
        }
        return defaultValue
    }

    private func encodeAndSet(_ value: T) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(value) {
            userDefaults.set(encoded, forKey: key)
        }
    }
}
