//
//  SelectedChoiceView.swift
//  Ranker
//
//  Created by Shyam Kumar on 9/30/21.
//

import UIKit

struct SelectedChoiceViewModel {
    var rank: Int
    var percent: Double
    var choiceName: String
    
    
    init(rank: Int = 1, percent: Double = 0, choiceName: String = "") {
        self.rank = rank
        self.percent = percent
        self.choiceName = choiceName
    }
}

class SelectedChoiceView: UIView {
    
    var model: SelectedChoiceViewModel = SelectedChoiceViewModel() {
        didSet {
            updateView()
        }
    }
    
    var animatedViewWidth: NSLayoutConstraint?
    
    lazy var animatedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .barGray
        view.layer.cornerRadius = 5
        animatedViewWidth = view.widthAnchor.constraint(equalToConstant: 0)
        animatedViewWidth?.isActive = true
        return view
    }()
    
    lazy var outerStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .equalSpacing
        
        stack.addArrangedSubview(innerStack)
        stack.addArrangedSubview(percentageLabel)
        return stack
    }()
    
    lazy var innerStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fill
        stack.spacing = 12
        
        stack.addArrangedSubview(choiceLabel)
        stack.addArrangedSubview(choiceColorView)
        return stack
    }()
    
    lazy var choiceLabel: UILabel = {
        let label = UILabel()
        label.font = .regularFont.withSize(12)
        label.textColor = .black
        return label
    }()
    
    lazy var choiceColorView: RankNumberView = {
        let view = RankNumberView()
        let model = RankNumberViewModel()
        view.model = model
        return view
    }()
    
    lazy var percentageLabel: UILabel = {
        let label = UILabel()
        label.font = .boldFont.withSize(12)
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
        addSubview(animatedView)
        addSubview(outerStack)
    }
    
    func setupConstraints() {
        animatedView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        animatedView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        animatedView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        outerStack.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        outerStack.topAnchor.constraint(equalTo: topAnchor).isActive = true
        outerStack.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        outerStack.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func animate() {
        animatedViewWidth?.constant = frame.width * CGFloat(model.percent)
        UIView.animate(withDuration: 0.4, animations: {
            self.layoutIfNeeded()
        })
    }
    
    func updateView() {
        percentageLabel.text = "\(Int(round(model.percent * 100)))%"
        choiceLabel.text = model.choiceName
        choiceColorView.model.rankNumber = model.rank
        switch(model.rank % 3) {
        case 1:
            choiceColorView.model.rankColor = .firstRed
        case 2:
            choiceColorView.model.rankColor = .secondTeal
        case 3:
            choiceColorView.model.rankColor = .thirdPurple
        default:
            return
        }
    }
}
