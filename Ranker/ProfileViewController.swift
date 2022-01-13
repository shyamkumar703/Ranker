//
//  ProfileViewController.swift
//  Ranker
//
//  Created by Shyam Kumar on 1/10/22.
//

import FirebaseFirestore
import UIKit

class ProfileViewController: UIViewController {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .regularFont.withSize(18)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontSizeToFitWidth = true
        label.text = "My polls"
        return label
    }()
    
    lazy var table: FeedTableView = {
        let table = FeedTableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        let db = Firestore.firestore()
        getTableModel { polls in
            table.model = FeedTableViewModel(
                polls: polls,
                emptyStateModel: EmptyStateModel(emptyType: .profile, delegate: self)
            )
        }
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if launchedWithID.0 {
            table.flashFirstCell()
        }
    }
    
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(table)
    }
    
    func setupConstraints() {
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 32).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        table.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12).isActive = true
        table.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        table.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
    }
    
    func getTableModel(completion: @escaping ([Poll]) -> Void) {
        let db = Firestore.firestore()
        db.getAll(collectionName: .polls, decodeInto: [Poll.self], completion: { polls in
            if let polls = polls {
                switch launchedWithID.0 {
                case true:
                    if let elementWithId = polls.filter({ $0.id == launchedWithID.1 }).first {
                        var filteredPolls = polls.filter({ $0.id != launchedWithID.1 })
                        filteredPolls.insert(elementWithId, at: 0)
                        completion(filteredPolls)
                    } else {
                        completion([])
                    }
                case false:
                    completion(polls.filter({ $0.getPollStatus() == .posted }))
                }
            } else {
                completion([])
            }
        })
    }
}

extension ProfileViewController: EmptyStateDelegate {
    var emptyStateTapped: Selector {
        get {
            return #selector(handleEmptyStateTap)
        }
    }
    
    @objc func handleEmptyStateTap() {
        feedback()
        present(CreatePollViewController(), animated: true, completion: nil)
    }
}
