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

struct Ranking {
    var score: Int
    var choice: PollChoice
    
    init(score: Int, choice: PollChoice) {
        self.score = score
        self.choice = choice
    }
    
    init(poll: Poll, choice: PollChoice) {
        self.choice = choice
        let filteredVotes = poll.votes.map({ $0.data.filter({ $0.1.id ==  choice.id }) })
        self.score = filteredVotes.reduce(0, { total, currVote in total + Ranking.voteToScore(vote: currVote) })
    }
    
    static func voteToScore(vote: [String: PollChoice]) -> Int {
        return vote.reduce(0, { total, vote in
            switch vote.key {
            case "1":
                return total + 10
            case "2":
                return total + 5
            case "3":
                return total + 3
            case "4":
                return total + 1
            case "5":
                return total + 0
            default:
                return 0
            }
        })
    }
}
