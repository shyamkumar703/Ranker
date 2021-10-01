//
//  PollView.swift
//  Ranker
//
//  Created by Shyam Kumar on 9/30/21.
//

import UIKit

class PollViewModel {
    var username: String
    var votesCast: Int
    var pollTitle: String
    var choices: [ChoiceViewModel]
    var currentRank: Int = 0
    
    init(username: String = "", votesCast: Int = 0, pollTitle: String = "", choices: [ChoiceViewModel] = []) {
        self.username = username
        self.votesCast = votesCast
        self.pollTitle = pollTitle
        self.choices = choices
    }
}

class PollView: UIView {
    
    var model: PollViewModel = PollViewModel() {
        didSet {
            updateView()
        }
    }
    
    lazy var outerStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 8
        
        stack.addArrangedSubview(titleStack)
        stack.addArrangedSubview(pollTitleLabel)
        stack.addArrangedSubview(choicesStack)
        return stack
    }()
    
    lazy var titleStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        
        stack.addArrangedSubview(usernameLabel)
        stack.addArrangedSubview(votesCastLabel)
        return stack
    }()
    
    lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        return label
    }()
    
    let usernameAttr: [NSAttributedString.Key: Any] = [
        .font: UIFont.regularFont.withSize(11),
        .foregroundColor: UIColor.choiceBlue
    ]
    
    let regularAttr: [NSAttributedString.Key: Any] = [
        .font: UIFont.regularFont.withSize(11),
        .foregroundColor: UIColor.black
    ]
    
    lazy var votesCastLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .regularFont.withSize(11)
        label.textColor = .voteTextGray
        return label
    }()
    
    lazy var pollTitleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldFont.withSize(15)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()
    
    lazy var choicesStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 8
        return stack
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
        addSubview(outerStack)
        layer.cornerRadius = 5
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.borderGray.cgColor
    }
    
    func setupConstraints() {
        outerStack.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        outerStack.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        outerStack.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        outerStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
    }
    
    func updateView() {
        for subview in choicesStack.arrangedSubviews {
            choicesStack.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
        
        for viewModel in model.choices {
            let view = ChoiceView()
            view.model = viewModel
            view.model.choiceSelection = { [self] in
                model.currentRank += 1
                return model.currentRank
            }
            view.heightAnchor.constraint(equalToConstant: 20).isActive = true
            choicesStack.addArrangedSubview(view)
        }
        
        // update username label
        let usernameText = NSMutableAttributedString(string: "@\(model.username) ", attributes: usernameAttr)
        let normalText = NSMutableAttributedString(string: "posted a poll", attributes: regularAttr)
        usernameText.append(normalText)
        usernameLabel.attributedText = usernameText
        
        // update votes label
        votesCastLabel.text = "\(model.votesCast) votes cast"
        
        // update poll title
        pollTitleLabel.text = model.pollTitle
    }
}
