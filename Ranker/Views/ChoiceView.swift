//
//  ChoiceView.swift
//  Ranker
//
//  Created by Shyam Kumar on 9/29/21.
//

import UIKit

class ChoiceView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    lazy var choiceButton: ChoiceButton = {
        let button = ChoiceButton()
        let model = ChoiceButtonModel(title: "Test", completion: buttonTap(model:))
        button.model = model
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var selectedChoice: SelectedChoiceView = {
        let view = SelectedChoiceView()
        let model = SelectedChoiceVieWModel(rank: 1, percent: 0.33)
        view.model = model
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
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
        addSubview(choiceButton)
    }
    
    func setupConstraints() {
        choiceButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        choiceButton.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        choiceButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        choiceButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func buttonTap(model: ChoiceButtonModel) {
        UIView.animate(withDuration: 0.3, animations: {
            self.choiceButton.alpha = 0
        }, completion: { [self] fin in
            choiceButton.removeFromSuperview()
            addSubview(selectedChoice)
            constrainSelectedChoice()
            UIView.animate(withDuration: 0.4, animations: {
                selectedChoice.alpha = 1
            }, completion: { fin in
                selectedChoice.animate()
            })
        })
    }
    
    func constrainSelectedChoice() {
        selectedChoice.topAnchor.constraint(equalTo: topAnchor).isActive = true
        selectedChoice.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        selectedChoice.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        selectedChoice.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    
}

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

struct SelectedChoiceVieWModel {
    var rank: Int
    var percent: Double
    
    init(rank: Int = 1, percent: Double = 0) {
        self.rank = rank
        self.percent = percent
    }
}

class SelectedChoiceView: UIView {
    
    var model: SelectedChoiceVieWModel = SelectedChoiceVieWModel() {
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
        stack.spacing = 8
        
        stack.addArrangedSubview(choiceRankLabel)
        stack.addArrangedSubview(choiceLabel)
//        stack.addArrangedSubview(choiceColorView)
        return stack
    }()
    
    lazy var choiceRankLabel: UILabel = {
        let label = UILabel()
        label.font = .boldFont.withSize(12)
        label.textColor = .choiceBlue
        return label
    }()
    
    lazy var choiceLabel: UILabel = {
        let label = UILabel()
        label.font = .regularFont.withSize(12)
        label.textColor = .black
        return label
    }()
    
    lazy var choiceColorView: UIView = {
        let view = UIView()
        view.heightAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        view.widthAnchor.constraint(equalToConstant: 12).isActive = true
        view.layer.cornerRadius = 6
        view.backgroundColor = .firstRed
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
        percentageLabel.text = "10%"
        choiceLabel.text = "Avatar"
        choiceRankLabel.text = "1"
    }
}
