//
//  NavigationBar.swift
//  Ranker
//
//  Created by Shyam Kumar on 1/4/22.
//

import Foundation
import UIKit

struct NavigationBarModel {
    var title: String
    var buttonArr: [UIButton]
    
    init(title: String = "Rankr", buttonArr: [UIButton] = []) {
        self.title = title
        self.buttonArr = buttonArr
    }
}

class NavigationBar: UIView {
    
    lazy var outerStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .equalSpacing
        stack.axis = .horizontal
        
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(buttonStack)
        return stack
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = .titleFont
        return label
    }()
    
    lazy var buttonStack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fillEqually
        stack.spacing = 12
        return stack
    }()
    
    var model = NavigationBarModel() {
        didSet {
            updateView()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(outerStack)
    }
    
    func setupConstraints() {
        outerStack.topAnchor.constraint(equalTo: topAnchor).isActive = true
        outerStack.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        outerStack.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        outerStack.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func updateView() {
        titleLabel.text = model.title
        for button in model.buttonArr { buttonStack.addArrangedSubview(button) }
    }
}
