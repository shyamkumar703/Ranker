//
//  Ranking.swift
//  Ranker
//
//  Created by Shyam Kumar on 9/25/21.
//

import Foundation

class Ranking {
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
}