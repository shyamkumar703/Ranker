//
//  ViewController.swift
//  Rankerz
//
//  Created by Shyam Kumar on 9/24/21.
//

import CoreLocation
import FirebaseFirestore
import UIKit

class ViewController: UIViewController {
    
    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
        return locationManager
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
    }
    
    func setupConstraints() {
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
