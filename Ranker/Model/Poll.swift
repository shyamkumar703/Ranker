//
//  Poll.swift
//  Ranker
//
//  Created by Shyam Kumar on 1/3/22.
//

import CoreLocation
import Foundation
import FirebaseFirestore

/*
 Firebase Structure
 ------------------
 postedBy: String
 id: String
 question: String
 choices: [PollChoice] (max of 5)
 date: Date
 latitude: Double
 longitude: Double
 */

enum PollStatus {
    case open
    case voted
    case posted
}

class Poll: Codable, Identifiable, DictDecode {
    var postedBy: String
    var id: String
    var question: String
    var choices: [PollChoice]
    var date: Date
    var latitude: Double?
    var longitude: Double?
    var votes: [Vote]
    
    init(
        postedBy: String = "",
        id: String = UUID().uuidString,
        question: String = "",
        choices: [PollChoice] = [],
        date: Date = Date(),
        votes: [Vote] = []
    ) {
        self.postedBy = postedBy
        self.id = id
        self.question = question
        self.choices = choices
        self.date = date
        
        let locationManager = CLLocationManager()
        locationManager.startUpdatingLocation()
        if let loc = locationManager.location {
            self.latitude = loc.coordinate.latitude
            self.longitude = loc.coordinate.longitude
        }
        
        self.votes = votes
    }
    
    enum Keys: String {
        case postedBy
        case id
        case question
        case choices
        case date
        case latitude
        case longitude
        case votes
    }
    
    func shouldIncludeInLocalFeed(currentLocation: CLLocation) -> Bool {
        if let lat = latitude,
           let long = longitude {
            let pollLocation = CLLocation(latitude: lat, longitude: long)
            let distance = pollLocation.distance(from: currentLocation).inMiles()
            if distance <= maxLocalDistance {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    static func initWith(dict: [String: Any]) -> Poll? {
        var poll = Poll()
        Poll.unwrap(poll: &poll, dict: dict)
        return poll
    }
    
    private static func unwrap(poll: inout Poll, dict: [String: Any]) {
        Utils.unwrap(
            object: &poll,
            paths: [\.postedBy, \.id, \.question],
            dict[Keys.postedBy.rawValue],
            dict[Keys.id.rawValue],
            dict[Keys.question.rawValue]
        )
        
        if let voteArr = dict[Keys.votes.rawValue] as? [[String: Any]] {
            poll.votes = voteArr.compactMap({ Vote.initWith(dict: $0) })
        }
        
        if let choiceArr = dict[Keys.choices.rawValue] as? [[String: Any]] {
            poll.choices = choiceArr.compactMap({ PollChoice.initWith(dict: $0)} )
        }
        
        if let timestamp = dict[Keys.date.rawValue] as? Timestamp {
            poll.date = Date(timeIntervalSince1970: TimeInterval(timestamp.seconds))
        }
        
        Utils.unwrap(
            object: &poll,
            paths: [\.latitude, \.longitude],
            dict[Keys.latitude.rawValue],
            dict[Keys.longitude.rawValue]
        )
    }
    
    func objectToDict() -> [String : Any] {
        return [
            Keys.postedBy.rawValue: postedBy,
            Keys.id.rawValue: id,
            Keys.question.rawValue: question,
            Keys.choices.rawValue: choices.map({ $0.objectToDict() }),
            Keys.date.rawValue: date,
            Keys.latitude.rawValue: latitude ?? 0,
            Keys.longitude.rawValue: longitude ?? 0,
            Keys.votes.rawValue: votes.map( {$0.objectToDict()} )
        ]
    }
    
    func addVote(vote: Vote) {
        votes.append(vote)
        let db = Firestore.firestore()
        db.update(collectionName: .polls, object: self)
    }
    
    func getPollStatus() -> PollStatus {
        if let uid = uid {
            if postedBy == uid { return .posted }
            if !votes.filter({ $0.id == uid }).isEmpty { return .voted }
        }
        return .open
    }
    
    func getTimeSincePost() -> String {
        let diff = abs(computeNewDate(from: date, to: Date()) ?? 0)
        if diff == 1 { return "1 min ago"}
        if diff < 60 { return "\(diff) mins ago"}
        if diff > 60 && diff < (60 * 24) { return "\(Int(diff / 60)) hrs ago" }
        if diff > (60 * 24) { return "\(Int(diff / (60 * 24))) days ago" }
        return "0 mins ago"
    }
    
    func computeNewDate(from fromDate: Date, to toDate: Date) -> Int? {
        return Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute
    }
}

extension CLLocationDistance {
    func inMiles() -> CLLocationDistance {
        return self * 0.00062137
    }
}
