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
        _ vals: String?...
    ) {
        for index in 0..<vals.count {
            object[keyPath: paths[index]] = vals[index] ?? ""
        }
    }

    static func unwrap<T>(
        object: inout T,
        paths: [WritableKeyPath<T, [String: Int]>],
        _ vals: [String: Int]?...
    ) {
        for index in 0..<vals.count {
            object[keyPath: paths[index]] = vals[index] ?? [:]
        }
    }
}
