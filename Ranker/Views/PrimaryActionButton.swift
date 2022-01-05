//
//  PrimaryActionButton.swift
//  Ranker
//
//  Created by Shyam Kumar on 1/4/22.
//

import UIKit

class PrimaryActionButton: UIView {
    
    var title: String = "" {
        didSet {
            updateView()
        }
    }
    
    var delegate: TapHandler? {
        didSet {
            updateView()
        }
    }
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        backgroundColor = .rBlue
        addSubview(button)
    }
    
    func setupConstraints() {
        button.topAnchor.constraint(equalTo: topAnchor).isActive = true
        button.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        button.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func updateView() {
        let attrs: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.regularFont.withSize(15)
        ]
        button.setAttributedTitle(NSAttributedString(string: title, attributes: attrs), for: .normal)
        if let delegate = delegate {
            button.addTarget(delegate, action: delegate.handleTap, for: .touchUpInside)
        }
    }
}
