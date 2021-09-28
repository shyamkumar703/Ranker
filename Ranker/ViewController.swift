//
//  ViewController.swift
//  Ranker
//
//  Created by Shyam Kumar on 9/24/21.
//

import UIKit
import FirebaseFirestore

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        let db = Firestore.firestore()
//        db.get(collectionName: .rankings, documentName: "OL143JahsN69JSSe0sOI", decodeInto: Ranking.self) { ranking in
//            print(ranking)
//        }
        db.getAll(collectionName: .rankings, decodeInto: [Ranking.self]) { rankings in
            if let rankings = rankings {
                for ranking in rankings {
                    print(ranking.name)
                }
            }
        }
    }
}
