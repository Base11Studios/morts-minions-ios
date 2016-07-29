//
//  EnumCollection.swift
//  Mort's Minions
//
//  Created by Dan Bellinski on 7/1/16.
//  Copyright © 2016 Dan Bellinski. All rights reserved.
//

import Foundation

protocol EnumCollection : Hashable {}
extension EnumCollection {
    static func cases() -> AnySequence<Self> {
        typealias S = Self
        return AnySequence { () -> AnyIterator<S> in
            var raw = 0
            return AnyIterator {
                let current : Self = withUnsafePointer(&raw) { UnsafePointer($0).pointee }
                guard current.hashValue == raw else { return nil }
                raw += 1
                return current
            }
        }
    }
}
