//
//  ViewController.swift
//  Ranker
//
//  Created by Shyam Kumar on 9/24/21.
//

import CoreLocation
import FirebaseFirestore
import UIKit

enum Scope {
    case local
    case global
}

class ViewController: UIViewController {
    
    var scope: Scope = .local {
        didSet {
            updateScope() {}
            switch scope {
            case .global:
                feedTable.model.emptyStateModel.emptyType = .nothing
            case .local:
                feedTable.model.emptyStateModel.emptyType = .feed
            }
            feedTable.updateView()
        }
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return rc
    }()
    
    lazy var locationButton: UIButton = {
        return buttonFactory(image: UIImage(systemName: "mappin"), action: #selector(scopeTapped))
    }()
    
    lazy var profileButton: UIButton = {
        return buttonFactory(image: UIImage(systemName: "person.fill"), action: #selector(profileTapped))
    }()
    
    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        return locationManager
    }()
    
    lazy var navigationBar: NavigationBar = {
        let model = NavigationBarModel(buttonArr: [locationButton, profileButton])
        let view = NavigationBar()
        view.model = model
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var feedTable: FeedTableView = {
        let table = FeedTableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.tableView.refreshControl = refreshControl
        updateScope {}
        return table
    }()
    
    lazy var fab: FAB = {
        let fab = FAB()
        fab.translatesAutoresizingMaskIntoConstraints = false
        fab.delegate = self
        return fab
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view
        UserDefaults.standard.set(true, forKey: Launch.hasLaunched.rawValue)
        setupView()
        setupConstraints()
    }
    
    func setupView() {
        view.backgroundColor = .white
        locationManager.requestAlwaysAuthorization()
        view.addSubview(navigationBar)
        view.addSubview(feedTable)
        view.addSubview(fab)
    }
    
    func setupConstraints() {
        navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        navigationBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        navigationBar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        navigationBar.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        feedTable.topAnchor.constraint(equalTo: navigationBar.bottomAnchor).isActive = true
        feedTable.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        feedTable.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        feedTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        fab.heightAnchor.constraint(equalToConstant: 40).isActive = true
        fab.widthAnchor.constraint(equalToConstant: 40).isActive = true
        fab.layer.cornerRadius = 20
        fab.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        fab.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
    }
    
    func buttonFactory(image: UIImage?, action: Selector) -> UIButton {
        let button = UIButton()
        button.addTarget(self, action: action, for: .touchUpInside)
        button.setImage(image, for: .normal)
        button.tintColor = .black
        return button
    }
    
    @objc func profileTapped() {
        feedback()
        present(ProfileViewController(), animated: true, completion: nil)
    }
    
    @objc func scopeTapped() {
        feedback()
        UIView.animate(
            withDuration: 0.2,
            animations: { [self] in
                locationButton.alpha = 0
                feedTable.alpha = 0
            },
            completion: { [self] _ in
                switch scope {
                case .local:
                    locationButton.setImage(UIImage(systemName: "globe"), for: .normal)
                    scope = .global
                case .global:
                    self.locationButton.setImage(UIImage(systemName: "mappin"), for: .normal)
                    scope = .local
                }
                updateScope {
                    UIView.animate(withDuration: 0.2, animations: {
                        locationButton.alpha = 1
                        feedTable.alpha = 1
                    })
                }
            }
        )
    }
    
    func updateScope(completion: @escaping () -> Void) {
        let db = Firestore.firestore()
        switch scope {
        case .local:
            db.getAll(collectionName: .polls, decodeInto: [Poll.self], completion: { [self] polls in
                let locationManager = CLLocationManager()
                locationManager.startUpdatingLocation()
                if let polls = polls ,
                   let loc = locationManager.location {
                    feedTable.model = FeedTableViewModel(
                        polls: polls.sorted(by: {$0.date > $1.date}).filter({ $0.shouldIncludeInLocalFeed(currentLocation: loc) }),
                        cellDelegate: self,
                        emptyStateModel: EmptyStateModel(emptyType: .feed, delegate: self)
                    )
                    completion()
                }
            })
        case .global:
            db.getAll(collectionName: .polls, decodeInto: [Poll.self], completion: { [self] polls in
                if let polls = polls {
                    feedTable.model = FeedTableViewModel(
                        polls: polls.sorted(by: {$0.date > $1.date}),
                        cellDelegate: self,
                        emptyStateModel: EmptyStateModel(emptyType: .nothing, delegate: self)
                    )
                    completion()
                }
            })
        }
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        updateScope {}
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension ViewController: TapHandler, CellDelegate, EmptyStateDelegate {
    var emptyStateTapped: Selector {
        get {
            return #selector(scopeTapped)
        }
    }
    
    var handleTap: Selector {
        get {
            return #selector(tapHandler)
        }
    }
    
    @objc func tapHandler() {
        feedback()
        present(CreatePollViewController(), animated: true, completion: nil)
    }
    
    func voteTapped(poll: Poll) {
        let vc = VoteViewController()
        vc.model = VoteViewControllerModel(poll: poll)
        present(vc, animated: true, completion: nil)
    }
}

extension ViewController: Reloadable {
    func reload(completion: @escaping () -> Void) {
        updateScope {
            completion()
        }
    }
    
    @objc func handleRefresh() {
        updateScope { [self] in
            refreshControl.endRefreshing()
        }
    }
}
