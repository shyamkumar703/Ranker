//
//  User.swift
//  Ranker
//
//  Created by Shyam Kumar on 9/28/21.
//

import Foundation
import FirebaseFirestore

class User: DictDecode, Codable {
    var id: String
    var username: String
    var voteData: VoteData
    
    init(username: String = "", id: String = UUID().uuidString, voteData: VoteData = VoteData()) {
        self.username = username
        self.id = id
        self.voteData = voteData
    }
    
    func objectToDict() -> [String : Any] {
        let dict: [String: Any] = [
            UserKeys.username.key: username,
            UserKeys.voteData.key: voteData.objectToDict()
        ]
        return dict
    }
    
    static func initWith(dict: [String: Any]) -> User {
        var user = User()
        User.unwrap(user: &user, voteData: &(user.voteData), dict: dict)
        return user
    }
    
    static func unwrap(user: inout User, voteData: inout VoteData, dict: [String: Any]) {
        Utils.unwrap(object: &user, paths: [\.username], dict[UserKeys.username.key] as? String)
        
        if let data = dict[UserKeys.voteData.key] as? [String: [Int: String]] {
            voteData.data = data
        }
    }
}

enum UserKeys: String, KeyProtocol {
    case username
    case voteData
    
    var key: String { rawValue }
}
