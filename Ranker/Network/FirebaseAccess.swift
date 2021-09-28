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
    func get<T: Codable>
    (
        db: Firestore,
        collectionName: Collections,
        documentName: String,
        decodeInto: T,
        completion: (T) -> Void
    ) {
        var docRef = db.collection(collectionName.name).document(documentName)
        docRef.getDocument { document, error in
            if let data = document?.data() {
                
            }
        }
    }
}

enum Collections: String {
    case users
    case rankings
    
    var name: String { rawValue }
}
