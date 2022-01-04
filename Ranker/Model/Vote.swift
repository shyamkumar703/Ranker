//
//  Vote.swift
//  Ranker
//
//  Created by Shyam Kumar on 9/28/21.
//

import Foundation

class Vote: Codable, Identifiable, DictDecode {
    
    // id = uid for this object
    // data is [rank: UID of PollChoice]
    var id: String
    var data: [String: PollChoice]
    
    init(id: String, data: [String: PollChoice]) {
        self.id = id
        self.data = data
    }
    
    convenience init?(data: [String: PollChoice] = [:]) {
        if let id = uid {
            self.init(id: id, data: data)
        } else {
            return nil
        }
    }
    
    enum Keys: String {
        case id
        case data
    }
    
    static func initWith(dict: [String: Any]) -> Vote? {
        if var vote = Vote(data: [:]) {
            Vote.unwrap(vote: &vote, dict: dict)
            return vote
        }
        return nil
    }
    
    private static func unwrap(vote: inout Vote, dict: [String: Any]) {
        Utils.unwrap(object: &vote, paths: [\.id], dict[Keys.id.rawValue])
        
        if let voteDict = dict[Keys.data.rawValue] as? [String: [String: Any]] {
            for (key, val) in voteDict {
                if let pollChoice = PollChoice.initWith(dict: val) {
                    vote.data[key] = pollChoice
                }
            }
        }
        
        Utils.unwrap(object: &vote, paths: [\.data], dict[Keys.data.rawValue])
    }
    
    func objectToDict() -> [String : Any] {
        var flattenedDict: [String: [String: Any]] = [:]
        for (key, value) in data {
            flattenedDict[key] = value.objectToDict()
        }
        return [
            Keys.id.rawValue: id,
            Keys.data.rawValue: flattenedDict
        ]
    }
}
