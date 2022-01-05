//
//  FAB.swift
//  Ranker
//
//  Created by Shyam Kumar on 1/4/22.
//

import Foundation
import UIKit

protocol TapHandler {
    var handleTap: Selector { get }
}

class FAB: UIView {
    
    var delegate: TapHandler? {
        didSet {
            updateView()
        }
    }
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .clear
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
        button.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        button.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func updateView() {
        if let delegate = delegate {
            button.addTarget(delegate, action: delegate.handleTap, for: .touchUpInside)
        }
    }
}
