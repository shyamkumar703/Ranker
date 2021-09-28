//
//  Ranking.swift
//  Ranker
//
//  Created by Shyam Kumar on 9/25/21.
//

import Foundation

protocol DictDecode {
    associatedtype ProtocolType
    var id: String { get set }
    static func initRankingWith(dict: [String: Any]) -> ProtocolType
    func objectToDict() -> [String: Any]
}

class Ranking: DictDecode {
    
    var choices: [String: Int]
    var name: String
    var id: String
    
    public init(choices: [String : Int] = [:], name: String = "", id: String = UUID().uuidString) {
        self.choices = choices
        self.name = name
        self.id = id
    }
    
    convenience init(choices: [String : Int] = [:], name: String = "", id: String = UUID().uuidString, pushToFirebase: Bool = false) {
        self.init(choices: choices, name: name, id: id)
        if pushToFirebase {
            // Add to firebase here
        }
    }
    
    static func initRankingWith(dict: [String: Any]) -> Ranking {
        var ranking = Ranking()
        Ranking.unwrap(ranking: &ranking, dict: dict)
        return ranking
    }
    
    static func unwrap(ranking: inout Ranking, dict: [String: Any]) {
        Utils.unwrap(object: &ranking, paths: [\.name, \.id], dict["name"] as? String, dict["id"] as? String)
        Utils.unwrap(object: &ranking, paths: [\.choices], dict["choices"] as? [String: Int])
    }
    
    func objectToDict() -> ([String : Any]) {
        let dict: [String: Any] = [
            RankingKeys.choices.rawValue: choices,
            RankingKeys.name.rawValue: name
        ]
        return dict
    }
}

enum RankingKeys: String {
    case choices
    case name
    
    var key: String { rawValue }
}
