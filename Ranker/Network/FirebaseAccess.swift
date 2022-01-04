//
//  FirebaseAccess.swift
//  Ranker
//
//  Created by Shyam Kumar on 9/24/21.
//

import Foundation
import FirebaseFirestore

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
                if var decode = T.self.initWith(dict: data) as? T {
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
            if let _ = err {
                completion(nil)
            } else {
                if let querySnapshot = querySnapshot {
                    var decoded: [T] = []
                    let documents = querySnapshot.documents
                    for index in 0..<documents.count {
                        let document = documents[index]
                        let id = document.documentID
                        let data = document.data()
                        if var decode = T.self.initWith(dict: data) as? T {
                            decode.id = id
                            decoded.append(decode)
                            if decoded.count == documents.count {
                                completion(decoded)
                            }
                        }
                    }
                    completion([])
                }
            }
        }
    }
    
    func add<T>(
        collectionName: Collections,
        object: T,
        completion: @escaping () -> Void
    ) where T: DictDecode {
        collection(collectionName.name).document(object.id).setData(object.objectToDict()) { err in
            if let err = err {
                print(err)
                // error handle here
            }
            completion()
        }
    }
    
    func update<Key, Value>(collectionName: Collections, document: String, keyName: Key, value: Value) where Key: KeyProtocol, Value: Codable {
        collection(collectionName.name).document(document).setData([keyName.key: value], merge: true)
    }
    
    func update<T>(collectionName: Collections, object: T) where T: DictDecode {
        collection(collectionName.name).document(object.id).setData(object.objectToDict())
    }
    
    func delete(collectionName: Collections, document: String) {
        collection(collectionName.name).document(document).delete()
    }
}

enum Collections: String {
    case polls
    
    var name: String { rawValue }
}
