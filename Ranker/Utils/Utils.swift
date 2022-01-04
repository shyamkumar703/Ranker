//
//  Utils.swift
//  Ranker
//
//  Created by Shyam Kumar on 9/25/21.
//

import Foundation

class Utils {
    
    static func unwrap<T>(
        object: inout T,
        paths: [WritableKeyPath<T, String>],
        _ vals: Any?...
    ) {
        for index in 0..<vals.count {
            if let val = vals[index] as? String? {
                object[keyPath: paths[index]] = val ?? ""
            }
        }
    }

    static func unwrap<T>(
        object: inout T,
        paths: [WritableKeyPath<T, [String: Int]>],
        _ vals: Any?...
    ) {
        for index in 0..<vals.count {
            if let val = vals[index] as? [String: Int]? {
                object[keyPath: paths[index]] = val ?? [:]
            }
        }
    }
    
    static func unwrap<T>(
        object: inout T,
        paths: [WritableKeyPath<T, [Int: Int]>],
        _ vals: Any?...
    ) {
        for index in 0..<vals.count {
            if let val = vals[index] as? [Int: Int]? {
                object[keyPath: paths[index]] = val ?? [:]
            }
        }
    }
    
    static func unwrap<T>(
        object: inout T,
        paths: [WritableKeyPath<T, [Vote]>],
        _ vals: Any?...
    ) {
        for index in 0..<vals.count {
            if let val = vals[index] as? [Vote]? {
                object[keyPath: paths[index]] = val ?? []
            }
        }
    }
    
    static func unwrap<T>(
        object: inout T,
        paths: [WritableKeyPath<T, [PollChoice]>],
        _ vals: Any?...
    ) {
        for index in 0..<vals.count {
            if let val = vals[index] as? [PollChoice]? {
                object[keyPath: paths[index]] = val ?? []
            }
        }
    }
    
    static func unwrap<T>(
        object: inout T,
        paths: [WritableKeyPath<T, Date>],
        _ vals: Any?...
    ) {
        for index in 0..<vals.count {
            if let val = vals[index] as? Date? {
                object[keyPath: paths[index]] = val ?? Date()
            }
        }
    }
    
    static func unwrap<T>(
        object: inout T,
        paths: [WritableKeyPath<T, Double?>],
        _ vals: Any?...
    ) {
        for index in 0..<vals.count {
            if let val = vals[index] as? Double? {
                object[keyPath: paths[index]] = val
            }
        }
    }
    
    static func unwrap<T>(
        object: inout T,
        paths: [WritableKeyPath<T, [String: PollChoice]>],
        _ vals: Any?...
    ) {
        for index in 0..<vals.count {
            if let val = vals[index] as? [String: PollChoice]? {
                object[keyPath: paths[index]] = val ?? [:]
            }
        }
    }
}
