//
//  VoteData.swift
//  Ranker
//
//  Created by Shyam Kumar on 9/28/21.
//

import Foundation

class VoteData: Codable {
    var data: [String: [Int: String]]
    
    init(data: [String: [Int: String]] = [:]) {
        self.data = data
    }
    
    func objectToDict() -> [String: Any] {
        data
    }
}
