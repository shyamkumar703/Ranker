//
//  ProfileViewController.swift
//  Ranker
//
//  Created by Shyam Kumar on 1/10/22.
//

import UIKit

// 8 * # of cells + (4 * (# of cells - 1))

class ProfileViewController: UIViewController {
    
    lazy var barChart: BarChart = {
        let chart = BarChart()
        chart.translatesAutoresizingMaskIntoConstraints = false
        return chart
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(barChart)
    }
    
    func setupConstraints() {
        barChart.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        barChart.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        barChart.heightAnchor.constraint(equalToConstant: 60).isActive = true
        barChart.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    }
}
