//
//  ViewController.swift
//  Rankerz
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
            updateScope()
        }
    }
    
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
        table.cellDelegate = self
        let db = Firestore.firestore()
        db.getAll(collectionName: .polls, decodeInto: [Poll.self], completion: { polls in
            if let polls = polls {
                table.model = FeedTableViewModel(polls: polls.sorted(by: {$0.date > $1.date}))
            }
        })
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
        switch scope {
        case .local:
            fadeInOutAnimation(
                view: locationButton,
                action: { self.locationButton.setImage(UIImage(systemName: "globe"), for: .normal) },
                duration: 0.2
            )
            scope = .global
        case .global:
            fadeInOutAnimation(
                view: locationButton,
                action: { self.locationButton.setImage(UIImage(systemName: "mappin"), for: .normal) },
                duration: 0.2
            )
            scope = .local
        }
    }
    
    func updateScope() {
    }
    
    func fadeInOutAnimation(view: UIView, action: @escaping () -> Void, duration: Double, completion: (() -> Void)? = nil) {
        UIView.animate(withDuration: duration, animations: {
            view.alpha = 0
        }, completion: { _ in
            action()
            UIView.animate(withDuration: duration, animations: {
                view.alpha = 1
            }, completion: { _ in
                completion?()
            })
        })
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

extension ViewController: TapHandler, CellDelegate {
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
        let db = Firestore.firestore()
        db.getAll(collectionName: .polls, decodeInto: [Poll.self], completion: { polls in
            if let polls = polls {
                self.feedTable.model = FeedTableViewModel(polls: polls.sorted(by: {$0.date > $1.date}))
                completion()
            }
        })
    }
}
