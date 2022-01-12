//
//  EmptyState.swift
//  Ranker
//
//  Created by Shyam Kumar on 1/11/22.
//

import UIKit

protocol EmptyStateDelegate {
    var emptyStateTapped: Selector { get }
}

enum EmptyType: String {
    case feed = "Go global"
    case profile = "Post a poll"
    case nothing = ""
    case locationFailure = "Settings"
}

struct EmptyStateModel {
    var emptyType: EmptyType
    var delegate: EmptyStateDelegate?
    
    init(emptyType: EmptyType = .feed, delegate: EmptyStateDelegate? = nil) {
        self.emptyType = emptyType
        self.delegate = delegate
    }
}

class EmptyState: UIView {
    
    let attributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.regularFont.withSize(13),
        .foregroundColor: UIColor.rBlue
    ]
    
    lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 8
        
        stack.addArrangedSubview(label)
        stack.addArrangedSubview(button)
        return stack
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.font = .regularFont.withSize(15)
        label.textAlignment = .center
        label.textColor = .black
        label.text = "Looks like there's nothing here."
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    lazy var button: UIButton = {
        let button = UIButton()
        button.tintColor = .rBlue
        button.backgroundColor = .clear
        button.setAttributedTitle(NSAttributedString(string: model.emptyType.rawValue, attributes: attributes), for: .normal)
        return button
    }()
    
    var model = EmptyStateModel() {
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
        backgroundColor = .clear
        addSubview(stack)
    }
    
    func setupConstraints() {
        stack.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        stack.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        stack.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        stack.heightAnchor.constraint(equalToConstant: label.intrinsicContentSize.height + button.intrinsicContentSize.height + 8).isActive = true
    }
    
    func updateView() {
        button.setAttributedTitle(NSAttributedString(string: model.emptyType.rawValue, attributes: attributes), for: .normal)
        if model.emptyType == .nothing {
            button.isEnabled = false
        } else {
            button.isEnabled = true
        }
        
        if let delegate = model.delegate {
            button.removeTarget(self, action: #selector(openSettings), for: .touchUpInside)
            button.addTarget(delegate, action: delegate.emptyStateTapped, for: .touchUpInside)
        }
        
        if model.emptyType == .locationFailure {
            label.text = "We need your location to personalize your feed."
            if let delegate = model.delegate {
                button.removeTarget(delegate, action: delegate.emptyStateTapped, for: .touchUpInside)
                button.addTarget(self, action: #selector(openSettings), for: .touchUpInside)
            }
        } else {
            label.text = "Looks like there's nothing here."
        }
    }
    
    @objc func openSettings() {
        guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        if UIApplication.shared.canOpenURL(settingsURL) {
            UIApplication.shared.open(settingsURL) { _ in return }
        }
    }
}
