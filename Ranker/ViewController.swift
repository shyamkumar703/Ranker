//
//  ViewController.swift
//  Ranker
//
//  Created by Shyam Kumar on 9/24/21.
//

import UIKit
import FirebaseFirestore

class ViewController: UIViewController {
    
    lazy var testView: ChoiceView = {
        let button = ChoiceView()
        let model = ChoiceViewModel(
            choiceTitle: "Avengers: Endgame",
            choiceSelection: { 2 },
            percentFirstChoice: 0.2
        )
        button.model = model
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        view.addSubview(testView)
        testView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        testView.centerYAnchor.constraint(lessThanOrEqualTo: view.centerYAnchor).isActive = true
        testView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        testView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
    }
}
