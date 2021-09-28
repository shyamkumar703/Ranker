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
        db.add(collectionName: .users, object: User(username: "jabrahams")) {}
    }
}
