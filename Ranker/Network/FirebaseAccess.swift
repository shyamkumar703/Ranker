//
//  FirebaseAccess.swift
//  Ranker
//
//  Created by Shyam Kumar on 9/24/21.
//

import Foundation
import FirebaseFirestore

public class FirebaseAccess {
    let db = Firestore.firestore()
}

extension Firestore  {
    func get<T>
    (
        collectionName: Collections,
        documentName: String,
        decodeInto: T.Type,
        completion: @escaping (T) -> Void
    ) where T: DictDecode {
        let docRef = collection(collectionName.name).document(documentName)
        docRef.getDocument { document, error in
            if let document = document,
               document.exists,
               let data = document.data() {
                if var decode = T.self.initRankingWith(dict: data) as? T {
                    decode.id = documentName
                    completion(decode)
                }
            }
        }
    }
    
    func getAll<T>
    (
        collectionName: Collections,
        decodeInto: [T.Type],
        completion: @escaping ([T]?) -> Void
    ) where T: DictDecode {
        
        collection(collectionName.name).getDocuments { querySnapshot, err in
            if let err = err {
                // Error handle here!
                print(err)
                completion(nil)
            } else {
                if let querySnapshot = querySnapshot {
                    var decoded: [T] = []
                    let documents = querySnapshot.documents
                    for index in 0..<documents.count {
                        let document = documents[index]
                        let id = document.documentID
                        let data = document.data()
                        if var decode = T.self.initRankingWith(dict: data) as? T {
                            decode.id = id
                            decoded.append(decode)
                            if decoded.count == documents.count {
                                completion(decoded)
                            }
                        }
                    }
                }
            }
        }
    }
}

enum Collections: String {
    case users
    case rankings
    
    var name: String { rawValue }
}
