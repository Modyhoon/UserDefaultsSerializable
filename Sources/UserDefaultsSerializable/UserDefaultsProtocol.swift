//
//  UserDefaultsProtocol.swift
//  UserDefaultsSerializable
//
//  Created by mody on 4/17/25.
//

import Foundation

public protocol UserDefaultsProtocol {
    func integer(forKey defaultName: String) -> Int
    func double(forKey defaultName: String) -> Double
    func float(forKey defaultName: String) -> Float
    func bool(forKey defaultName: String) -> Bool
    func string(forKey defaultName: String) -> String?
    func data(forKey defaultName: String) -> Data?
    func array(forKey defaultName: String) -> [Any]?
    func dictionary(forKey defaultName: String) -> [String: Any]?
    func object(forKey defaultName: String) -> Any?
    func set(_ value: Any?, forKey defaultName: String)
    func removeObject(forKey defaultName: String)
}

extension UserDefaults: UserDefaultsProtocol {}
