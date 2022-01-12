//
//  PrimaryActionButton.swift
//  Ranker
//
//  Created by Shyam Kumar on 1/4/22.
//

import UIKit

class PrimaryActionButton: UIView {
    
    let attrs: [NSAttributedString.Key: Any] = [
        .foregroundColor: UIColor.white,
        .font: UIFont.regularFont.withSize(15)
    ]
    
    let disabledAttrs: [NSAttributedString.Key: Any] = [
        .foregroundColor: UIColor.lightGray,
        .font: UIFont.regularFont.withSize(15)
    ]
    
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
        layer.cornerRadius = 10
    }
    
    func setupConstraints() {
        button.topAnchor.constraint(equalTo: topAnchor).isActive = true
        button.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        button.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func updateView() {
        button.setAttributedTitle(NSAttributedString(string: title, attributes: attrs), for: .normal)
        if let delegate = delegate {
            button.addTarget(delegate, action: delegate.handleTap, for: .touchUpInside)
        }
    }
    
    func disable() {
        button.isEnabled = false
        UIView.animate(withDuration: 0.2, animations: { self.button.backgroundColor = .lightGray })
    }
    
    func enable() {
        button.isEnabled = true
        UIView.animate(withDuration: 0.2, animations: { self.button.backgroundColor = .rBlue })
    }
}
