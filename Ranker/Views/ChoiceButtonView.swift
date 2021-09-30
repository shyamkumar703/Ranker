//
//  ChoiceButtonView.swift
//  Ranker
//
//  Created by Shyam Kumar on 9/30/21.
//

import UIKit

struct ChoiceButtonModel {
    var title: String
    var completion: (ChoiceButtonModel) -> Void
    
    init
    (
        title: String = "",
        completion: @escaping (ChoiceButtonModel) -> Void = { _ in return }
    ) {
        self.title = title
        self.completion = completion
    }
}

class ChoiceButton: UIView {
    
    var model: ChoiceButtonModel = ChoiceButtonModel() {
        didSet {
            updateView()
        }
    }
    
    lazy var choiceLabel: UILabel = {
        let label = UILabel()
        label.font = .regularFont.withSize(12)
        label.textColor = .choiceBlue
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
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
        layer.cornerRadius = 5
        layer.borderColor = UIColor.choiceBlue.cgColor
        layer.borderWidth = 0.5
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        addGestureRecognizer(tapGesture)
        
        addSubview(choiceLabel)
    }
    
    func setupConstraints() {
        choiceLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        choiceLabel.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        choiceLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        choiceLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func updateView() {
        choiceLabel.text = model.title
    }
    
    @objc func viewTapped() {
        model.completion(model)
    }
}
