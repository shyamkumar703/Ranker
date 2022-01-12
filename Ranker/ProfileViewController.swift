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
        db.getAll(collectionName: .polls, decodeInto: [Poll.self], completion: { polls in
            if let polls = polls {
                table.model = FeedTableViewModel(
                    polls: polls.filter({ $0.getPollStatus() == .posted }),
                    emptyStateModel: EmptyStateModel(emptyType: .profile, delegate: self)
                )
            }
        })
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
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
