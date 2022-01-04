//
//  Protocols.swift
//  Ranker
//
//  Created by Shyam Kumar on 9/28/21.
//

import Foundation

// Enums corresponding to Firebase keys
protocol KeyProtocol {
    var key: String { get }
}

// Classes with a direct correspondence to Firebase objects
protocol DictDecode {
    associatedtype ProtocolType
    var id: String { get set }
    static func initWith(dict: [String: Any]) -> ProtocolType?
    func objectToDict() -> [String: Any]
}
