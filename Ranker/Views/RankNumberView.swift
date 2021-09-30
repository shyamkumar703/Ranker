//
//  RankNumberView.swift
//  Ranker
//
//  Created by Shyam Kumar on 9/30/21.
//

import UIKit

struct RankNumberViewModel {
    var rankNumber: Int
    var rankColor: UIColor
    
    init(rankNumber: Int = 1, rankColor: UIColor = .firstRed) {
        self.rankColor = rankColor
        self.rankNumber = rankNumber
    }
}

class RankNumberView: UIView {
    
    var model: RankNumberViewModel = RankNumberViewModel() {
        didSet {
            updateView()
        }
    }
    
    lazy var rankLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 6
        label.heightAnchor.constraint(equalToConstant: 12).isActive = true
        label.widthAnchor.constraint(equalToConstant: 12).isActive = true
        label.textAlignment = .center
        label.font = .regularFont.withSize(8)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(rankLabel)
    }
    
    func setupConstraints() {
        rankLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        rankLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    func updateView() {
        rankLabel.text = "\(model.rankNumber)"
        rankLabel.backgroundColor = model.rankColor
    }
}
