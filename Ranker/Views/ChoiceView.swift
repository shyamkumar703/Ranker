//
//  ChoiceView.swift
//  Ranker
//
//  Created by Shyam Kumar on 9/29/21.
//

import UIKit

struct ChoiceViewModel {
    var choiceTitle: String
    var choiceSelection: () -> Int
    var percentFirstChoice: Double
    
    init
    (
        choiceTitle: String = "",
        choiceSelection: @escaping () -> Int = { 1 },
        percentFirstChoice: Double = 0
    ) {
        self.choiceTitle = choiceTitle
        self.choiceSelection = choiceSelection
        self.percentFirstChoice = percentFirstChoice
    }
}

class ChoiceView: UIView {
    
    var model: ChoiceViewModel = ChoiceViewModel() {
        didSet {
            updateView()
        }
    }
    
    lazy var choiceButton: ChoiceButton = {
        let button = ChoiceButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var selectedChoice: SelectedChoiceView = {
        let view = SelectedChoiceView()
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
        selectedChoice.model.rank = self.model.choiceSelection()
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
    
    func updateView() {
        selectedChoice.model = SelectedChoiceViewModel(percent: model.percentFirstChoice, choiceName: model.choiceTitle)
        choiceButton.model = ChoiceButtonModel(title: model.choiceTitle, completion: buttonTap(model:))
    }
}
