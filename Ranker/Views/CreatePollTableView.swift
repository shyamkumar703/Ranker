//
//  CreatePollTableView.swift
//  Ranker
//
//  Created by Shyam Kumar on 1/4/22.
//

import UIKit

fileprivate var cellId: String = "create"

class CreatePollTableView: UIView {
    
    var model: Poll? = {
        if let uid = uid {
            let poll = Poll(
                postedBy: uid,
                question: "",
                choices: [
                    PollChoice(title: "", color: Color.red.rawValue),
                    PollChoice(title: "", color: Color.blue.rawValue)
                ]
            )
            return poll
        }
        return nil
    }() {
        didSet {
            updateView()
        }
    }
    
    var modelDelegate: ModelDelegate?
    
    lazy var addOptionFooterButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        let titleAttributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.regularFont.withSize(12),
            .foregroundColor: UIColor.rBlue
        ]
        button.setAttributedTitle(NSAttributedString(string: "Add option", attributes: titleAttributes), for: .normal)
        button.tintColor = .rBlue
        button.addTarget(self, action: #selector(addOption), for: .touchUpInside)
        button.isEnabled = true
        return button
    }()
    
    lazy var footerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 24))
        view.backgroundColor = .clear
        view.addSubview(addOptionFooterButton)
        
        addOptionFooterButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 4).isActive = true
        addOptionFooterButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8).isActive = true
        addOptionFooterButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        return view
    }()
    
    lazy var tableView: UITableView = {
        // add plus button as table view footer, disable when 5
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.dataSource = self
        tv.register(CreatePollTableViewCell.self, forCellReuseIdentifier: cellId)
        tv.separatorStyle = .none
        tv.allowsSelection = false
        tv.tableFooterView = footerView
        tv.tableFooterView?.backgroundColor = .clear
        return tv
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
        backgroundColor = .clear
        addSubview(tableView)
    }
    
    func setupConstraints() {
        tableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func updateView() {
        tableView.reloadData()
    }
    
    @objc func addOption() {
        if let model = model {
            feedback()
            switch model.choices.count {
            case 2:
                model.choices.append(PollChoice(title: "", color: Color.pink.rawValue))
            case 3:
                model.choices.append(PollChoice(title: "", color: Color.purple.rawValue))
            case 4:
                model.choices.append(PollChoice(title: "", color: Color.teal.rawValue))
            default:
                model.choices.append(PollChoice(title: "", color: Color.red.rawValue))
            }
            tableView.insertRows(at: [IndexPath(item: model.choices.count - 1, section: 0)], with: .fade)
            if model.choices.count == 5 {
                let disabledAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.regularFont.withSize(12),
                    .foregroundColor: UIColor.lightGray
                ]
                addOptionFooterButton.setAttributedTitle(NSAttributedString(string: "Add option", attributes: disabledAttributes), for: .normal)
                addOptionFooterButton.isEnabled = false
            } else {
                let titleAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.regularFont.withSize(12),
                    .foregroundColor: UIColor.rBlue
                ]
                addOptionFooterButton.setAttributedTitle(NSAttributedString(string: "Add option", attributes: titleAttributes), for: .normal)
                addOptionFooterButton.isEnabled = true
            }
        }
    }
}

extension CreatePollTableView: UITableViewDelegate, UITableViewDataSource, ChoiceDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.choices.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? CreatePollTableViewCell {
            cell.model = CellModel(row: indexPath.row + 1, pc: model?.choices[indexPath.row], choiceDelegate: self)
            return cell
        }
        return UITableViewCell()
    }
    
    func choiceChanged() {
        guard let model = model else { return }
        modelDelegate?.modelChanged(model: model)
    }
}

protocol ChoiceDelegate {
    func choiceChanged()
}

struct CellModel {
    var row: Int
    var pc: PollChoice
    var choiceDelegate: ChoiceDelegate?
    
    init?(row: Int, pc: PollChoice?, choiceDelegate: ChoiceDelegate? = nil) {
        self.row = row
        if let pc = pc {
            self.pc = pc
        } else {
            return nil
        }
        self.choiceDelegate = choiceDelegate
    }
}

class CreatePollTableViewCell: UITableViewCell, ColorSelectorDelegate, UITextFieldDelegate {
    
    var model: CellModel? {
        didSet {
            updateView()
        }
    }
    
    lazy var outerStack: UIStackView = {
        let stack = UIStackView()
        stack.distribution = .fill
        stack.axis = .vertical
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var iv: UIView = {
        let iv = UIView()
        iv.backgroundColor = UIColor.getColor(str: model?.pc.color ?? "")?.color ?? .rRed
        iv.heightAnchor.constraint(equalToConstant: 12).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 12).isActive = true
        iv.layer.cornerRadius = 6
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    lazy var field: UITextField = {
        let field = UITextField()
        field.adjustsFontSizeToFitWidth = true
        field.textColor = .black
        field.font = .regularFont
        field.translatesAutoresizingMaskIntoConstraints = false
        field.delegate = self
        return field
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        contentView.addSubview(outerStack)
    }
    
    func setupConstraints() {
        outerStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        outerStack.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true
        outerStack.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
    }
    
    func fieldColorFactory() -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        view.addSubview(iv)
        view.addSubview(field)
        
        if let model = model {
            // field
            field.placeholder = "Option \(model.row)"
            // constraints
            iv.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            iv.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            field.leftAnchor.constraint(equalTo: iv.rightAnchor, constant: 12).isActive = true
            field.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            field.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            field.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        }
        return view
    }
    
    func updateView() {
        if model != nil {
            outerStack.addArrangedSubview(fieldColorFactory())
        }
    }
    
    func selectionChanged(color: UIColor?) {
        // color to string conversion needed
        UIView.animate(withDuration: 0.2, animations: {
            self.iv.backgroundColor = color
        })
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        model?.pc.title = text
        model?.choiceDelegate?.choiceChanged()
    }
}
