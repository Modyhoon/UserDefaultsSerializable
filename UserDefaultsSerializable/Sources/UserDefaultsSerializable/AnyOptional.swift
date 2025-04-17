//
//  AnyOptional.swift
//  UserDefaultsSerializable
//
//  Created by mody on 4/17/25.
//

import Foundation

protocol AnyOptional {
    associatedtype Wrapped

    var wrappedValue: Wrapped? { get }
    static var wrappedType: Wrapped.Type { get }
}

extension Optional: AnyOptional {
    static var wrappedType: Wrapped.Type {
        Wrapped.self
    }

    var wrappedValue: Wrapped? {
        switch self {
        case .none:
            return nil

        case let .some(value):
            return value
        }
    }
}
