//
//  LaunchViewController.swift
//  Ranker
//
//  Created by Shyam Kumar on 1/12/22.
//

import UIKit

class LaunchViewController: UIViewController {
    
    var colors: [UIColor] = [.rRed, .rBlue, .rPink, .rPurple, .rTeal]
    
    lazy var outerStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 16
        
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(colorStack)
        return stack
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Rankr"
        label.textColor = .black
        label.textAlignment = .center
        label.font = .regularFont.withSize(20)
        return label
    }()
    
    lazy var colorStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        return stack
    }()
    
    lazy var pab: PrimaryActionButton = {
        let pab = PrimaryActionButton()
        pab.delegate = self
        pab.title = "Get started"
        pab.alpha = 0
        pab.translatesAutoresizingMaskIntoConstraints = false
        return pab
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        animate()
    }
    
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(outerStack)
        view.addSubview(pab)
        for color in colors {
            colorStack.addArrangedSubview(colorFactory(color: color))
        }
    }
    
    func setupConstraints() {
        outerStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        outerStack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        outerStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 80).isActive = true
        outerStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -80).isActive = true
        
        pab.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        pab.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        pab.heightAnchor.constraint(equalToConstant: 36).isActive = true
        pab.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
    }
    
    func colorFactory(color: UIColor) -> UIView {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: 16).isActive = true
        view.widthAnchor.constraint(equalToConstant: 16).isActive = true
        view.layer.cornerRadius = 8
        view.backgroundColor = color
        view.isHidden = true
        return view
    }
    
    func animate() {
        for view in colorStack.arrangedSubviews { animateView(view: view) }
        animatePab()
    }
    
    func animatePab() {
        UIView.animate(
            withDuration: 0.2,
            delay: 0.6,
            animations: { [self] in
                pab.alpha = 1
            },
            completion: { _ in feedback() }
        )
    }
    
    func animateView(view: UIView) {
        UIView.animate(
            withDuration: 0.2,
            delay: 0.4,
            options: .curveEaseInOut,
            animations: { [self] in
                view.isHidden = false
                colorStack.layoutIfNeeded()
            },
            completion: { _ in
                feedback()
            }
        )
    }
}

extension LaunchViewController: TapHandler {
    var handleTap: Selector {
        return #selector(getStartedTapped)
    }
    
    @objc func getStartedTapped() {
        feedback()
        let vc = ViewController()
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}
