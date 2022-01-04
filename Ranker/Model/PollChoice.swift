//
//  PollChoice.swift
//  Ranker
//
//  Created by Shyam Kumar on 1/3/22.
//

import Foundation
import UIKit

/*
 Firebase Structure
 ------------------
 id: String
 title: String
 votes: [Int: Int] (1: 10, 2: 5, ...) Place: Votes
 color: String
 */

class PollChoice: Codable, Identifiable, DictDecode {
    var id: String
    var title: String
    var color: String
    
    init(
        id: String = UUID().uuidString,
        title: String = "",
        color: String = Color.red.rawValue
    ) {
        self.id = id
        self.title = title
        self.color = color
    }
    
    enum Keys: String {
        case id
        case title
        case color
    }
    
    static func initWith(dict: [String: Any]) -> PollChoice? {
        var pollChoice = PollChoice()
        PollChoice.unwrap(pollChoice: &pollChoice, dict: dict)
        return pollChoice
    }
    
    private static func unwrap(pollChoice: inout PollChoice, dict: [String: Any]) {
        Utils.unwrap(object: &pollChoice, paths: [\.id, \.title, \.color], dict[Keys.id.rawValue], dict[Keys.title.rawValue], dict[Keys.color.rawValue])
    }
    
    func objectToDict() -> [String : Any] {
        return [
            Keys.id.rawValue: id,
            Keys.title.rawValue: title,
            Keys.color.rawValue: color
        ]
    }
}
