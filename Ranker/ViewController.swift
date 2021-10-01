//
//  ViewController.swift
//  Ranker
//
//  Created by Shyam Kumar on 9/24/21.
//

import UIKit
import FirebaseFirestore

class ViewController: UIViewController {
    
    lazy var feed: FeedTableView = {
        let view = FeedTableView()
        let model = FeedTableViewModel(
            cells: [
                PollViewModel(
                    username: "jabrahams",
                    votesCast: 12,
                    pollTitle: "asl;dfj;asl",
                    choices: [
                        ChoiceViewModel(
                            choiceTitle: "asdfasdf",
                            percentFirstChoice: 0.1
                        ),
                        ChoiceViewModel(
                            choiceTitle: "asdfasdggsadf",
                            percentFirstChoice: 0.5
                        ),
                        ChoiceViewModel(
                            choiceTitle: "asdgawegasefasdf",
                            percentFirstChoice: 0.8
                        )
                    ]
                ),
                PollViewModel(
                    username: "jabrahams",
                    votesCast: 12,
                    pollTitle: "asl;dfj;asl",
                    choices: [
                        ChoiceViewModel(
                            choiceTitle: "asdfasdf",
                            percentFirstChoice: 0.1
                        ),
                        ChoiceViewModel(
                            choiceTitle: "asdfasdggsadf",
                            percentFirstChoice: 0.5
                        ),
                        ChoiceViewModel(
                            choiceTitle: "asdgawegasefasdf",
                            percentFirstChoice: 0.8
                        )
                    ]
                ),
                PollViewModel(
                    username: "jabrahams",
                    votesCast: 12,
                    pollTitle: "asl;dfj;asl",
                    choices: [
                        ChoiceViewModel(
                            choiceTitle: "asdfasdf",
                            percentFirstChoice: 0.1
                        ),
                        ChoiceViewModel(
                            choiceTitle: "asdfasdggsadf",
                            percentFirstChoice: 0.5
                        ),
                        ChoiceViewModel(
                            choiceTitle: "asdgawegasefasdf",
                            percentFirstChoice: 0.8
                        )
                    ]
                )
            ]
        )
        view.model = model
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var navigationBarView: NavigationBarView = {
        let view = NavigationBarView()
        let model = NavigationBarViewModel(username: "jabrahams")
        view.model = model
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        setupView()
        setupConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        navigationItem.titleView = navigationBarView
    }
    
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(feed)
    }
    
    func setupConstraints() {
        feed.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        feed.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        feed.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        feed.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
    }
}
