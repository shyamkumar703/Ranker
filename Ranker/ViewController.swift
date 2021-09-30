//
//  ViewController.swift
//  Ranker
//
//  Created by Shyam Kumar on 9/24/21.
//

import UIKit
import FirebaseFirestore

class ViewController: UIViewController {
    
    lazy var testView: PollView = {
        let view = PollView()
        let choiceModel = ChoiceViewModel(
            choiceTitle: "Avengers: Endgame",
            percentFirstChoice: 0.2
        )
        let model = PollViewModel(username: "jabrahams", votesCast: 127, pollTitle: "Top Three Movies", choices: [choiceModel, choiceModel, choiceModel, choiceModel, choiceModel, choiceModel])
        view.model = model
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        view.addSubview(testView)
        testView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        testView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        testView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
    }
}
