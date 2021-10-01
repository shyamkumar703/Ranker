//
//  NavigationBarView.swift
//  Ranker
//
//  Created by Shyam Kumar on 9/30/21.
//

import UIKit

struct NavigationBarViewModel {
    var username: String
    
    init(username: String = "") {
        self.username = username
    }
}

class NavigationBarView: UIView {
    
    var model: NavigationBarViewModel = NavigationBarViewModel() {
        didSet {
            updateView()
        }
    }
    
    lazy var outerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.addArrangedSubview(usernameLabel)
        return stack
    }()
    
    lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .boldFont
        label.textColor = .black
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
        backgroundColor = .clear
        addSubview(outerStack)
    }
    
    func setupConstraints() {
        outerStack.topAnchor.constraint(equalTo: topAnchor).isActive = true
        outerStack.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        outerStack.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        outerStack.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func updateView() {
        usernameLabel.text = model.username
    }
}
