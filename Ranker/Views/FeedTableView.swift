//
//  FeedTableView.swift
//  Ranker
//
//  Created by Shyam Kumar on 1/4/22.
//

import Foundation
import UIKit

fileprivate var cellId: String = "poll"
fileprivate var votedCellId: String = "voted"

struct FeedTableViewModel {
    var polls: [Poll]
    var cellDelegate: CellDelegate?
    var emptyStateModel: EmptyStateModel
    init(polls: [Poll] = [], cellDelegate: CellDelegate? = nil, emptyStateModel: EmptyStateModel = EmptyStateModel()) {
        self.polls = polls
        self.cellDelegate = cellDelegate
        self.emptyStateModel = emptyStateModel
    }
}

class FeedTableView: UIView {
    
    var model = FeedTableViewModel() {
        didSet {
            updateView()
        }
    }
    
    lazy var emptyState: EmptyState = {
        let view = EmptyState()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = .white
        tv.register(PollCell.self, forCellReuseIdentifier: cellId)
        tv.register(VotedPollCell.self, forCellReuseIdentifier: votedCellId)
        tv.showsVerticalScrollIndicator = false
        tv.showsHorizontalScrollIndicator = false
        
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 100))
        footer.backgroundColor = .white
        tv.tableFooterView = footer
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
        backgroundColor = .white
        addSubview(tableView)
        addSubview(emptyState)
    }
    
    func setupConstraints() {
        emptyState.topAnchor.constraint(equalTo: topAnchor).isActive = true
        emptyState.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        emptyState.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        emptyState.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        tableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    func updateView() {
        DispatchQueue.main.async { [self] in
            emptyState.model = model.emptyStateModel
            
            if model.polls.count == 0 {
                tableView.alpha = 0
                emptyState.alpha = 1
                return
            }
            
            emptyState.alpha = 0
            tableView.alpha = 1
            tableView.reloadData()
        }
    }
}

extension FeedTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.polls.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if model.polls[indexPath.row].getPollStatus() != .open {
            if let cell = tableView.dequeueReusableCell(withIdentifier: votedCellId, for: indexPath) as? VotedPollCell {
                cell.delegate = model.cellDelegate
                cell.model = model.polls[indexPath.row]
                cell.selectionStyle = .none
                return cell
            }
        } else {
            if let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? PollCell {
                cell.delegate = model.cellDelegate
                cell.model = model.polls[indexPath.row]
                cell.selectionStyle = .none
                return cell
            }
        }
        return UITableViewCell()
    }
}

protocol CellDelegate {
    func voteTapped(poll: Poll)
}

class PollCell: UITableViewCell {
    
    var model = Poll() {
        didSet {
            updateView()
        }
    }
    
    var delegate: CellDelegate?
    
    lazy var outerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 12
        return stack
    }()
    
    lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
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
        backgroundColor = .clear
        contentView.addSubview(outerStack)
    }
    
    func setupConstraints() {
        outerStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        outerStack.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
        outerStack.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true
        outerStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
    }
    
    func choicesStackFactory(choice: PollChoice) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        // Circle
        let iv = UIView()
        iv.heightAnchor.constraint(equalToConstant: 10).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 10).isActive = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 5
        iv.backgroundColor = UIColor.getColor(str: choice.color)?.color
        view.addSubview(iv)
        // Label
        let label = UILabel()
        label.text = choice.title
        label.textAlignment = .left
        label.font = .regularFont.withSize(13)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        // Constraints
        iv.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        iv.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: iv.rightAnchor, constant: 8).isActive = true
        label.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        label.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        return view
    }
    
    func updateView() {
        // Title label
        let standardAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.regularFont.withSize(13), .foregroundColor: UIColor.black.withAlphaComponent(0.5)]
        let questionAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.regularFont.withSize(13), .foregroundColor: UIColor.black]
        let attrString = NSMutableAttributedString(string: "Someone wants to know\n", attributes: standardAttributes)
        let questionAttr = NSMutableAttributedString(string: "\(model.question)", attributes: questionAttributes)
        attrString.append(questionAttr)
        questionLabel.attributedText = attrString
        outerStack.addArrangedSubview(questionLabel)
        // Choices stack
        for choice in model.choices { outerStack.addArrangedSubview(choicesStackFactory(choice: choice)) }
        // Details view
        let detailsStack = UIStackView()
        detailsStack.axis = .horizontal
        detailsStack.distribution = .equalSpacing
        // vote button
        let label = UILabel()
        label.textColor = .black.withAlphaComponent(0.5)
        label.textAlignment = .left
        label.font = .regularFont.withSize(11)
        switch model.getPollStatus() {
        case .open:
            label.text = "Vote on this poll..."
            label.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(voteTapped))
            label.addGestureRecognizer(tapGesture)
        case .voted:
            label.text = "You've already voted on this poll."
        case .posted:
            label.text = "Your poll"
        }
        detailsStack.addArrangedSubview(label)
        // time label
        let time = UILabel()
        time.textAlignment = .right
        time.textColor = .black.withAlphaComponent(0.5)
        time.text = model.getTimeSincePost()
        time.font = .regularFont.withSize(11)
        detailsStack.addArrangedSubview(time)
        outerStack.addArrangedSubview(detailsStack)
    }
    
    @objc func voteTapped() {
        delegate?.voteTapped(poll: model)
    }
    
    override func prepareForReuse() {
        for subview in outerStack.arrangedSubviews {
            outerStack.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
    }
}

class VotedPollCell: UITableViewCell {
    
    var model = Poll() {
        didSet {
            updateView()
        }
    }
    
    var delegate: CellDelegate?
    
    lazy var outerStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.spacing = 12
        return stack
    }()
    
    lazy var barChart: BarChart = {
        let chart = BarChart()
        chart.translatesAutoresizingMaskIntoConstraints = false
        chart.heightAnchor.constraint(equalToConstant: 60).isActive = true
        return chart
    }()
    
    lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
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
        backgroundColor = .clear
        contentView.addSubview(outerStack)
    }
    
    func setupConstraints() {
        outerStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        outerStack.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
        outerStack.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true
        outerStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
    }
    
    func choicesStackFactory(choice: PollChoice, rank: Int = 1) -> UIView {
        let view = UIView()
        view.backgroundColor = .clear
        // Rank Label
        let rankLabel = UILabel()
        rankLabel.textAlignment = .center
        rankLabel.font = .regularFont.withSize(13)
        rankLabel.textColor = .black
        rankLabel.text = "\(rank)"
        rankLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(rankLabel)
        // Circle
        let iv = UIView()
        iv.heightAnchor.constraint(equalToConstant: 10).isActive = true
        iv.widthAnchor.constraint(equalToConstant: 10).isActive = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 5
        iv.backgroundColor = UIColor.getColor(str: choice.color)?.color
        view.addSubview(iv)
        // Label
        let label = UILabel()
        label.text = choice.title
        label.textAlignment = .left
        label.font = .regularFont.withSize(13)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        // Constraints
        rankLabel.widthAnchor.constraint(equalToConstant: 8).isActive = true
        rankLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        rankLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        iv.leftAnchor.constraint(equalTo: rankLabel.rightAnchor, constant: 8).isActive = true
        iv.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        label.leftAnchor.constraint(equalTo: iv.rightAnchor, constant: 8).isActive = true
        label.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        label.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        return view
    }
    
    func updateView() {
        // Title label
        let standardAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.regularFont.withSize(13), .foregroundColor: UIColor.black.withAlphaComponent(0.5)]
        let questionAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.regularFont.withSize(13), .foregroundColor: UIColor.black]
        let attrString = NSMutableAttributedString(string: "Someone wants to know\n", attributes: standardAttributes)
        let questionAttr = NSMutableAttributedString(string: "\(model.question)", attributes: questionAttributes)
        attrString.append(questionAttr)
        questionLabel.attributedText = attrString
        outerStack.addArrangedSubview(questionLabel)
        // Bar chart
        let rankings = model.getRankings()
        barChart.dataPoints = rankings.map({ $0.score })
        barChart.colors = rankings.map({ UIColor.getColor(str: $0.choice.color)?.color ?? .rRed })
//        barChart.reload()
        outerStack.addArrangedSubview(barChart)
        // Choices stack
        for (i, ranking) in rankings.enumerated() {
            outerStack.addArrangedSubview(choicesStackFactory(choice: ranking.choice, rank: i + 1))
        }
        // Details view
        let detailsStack = UIStackView()
        detailsStack.axis = .horizontal
        detailsStack.distribution = .equalSpacing
        // vote button
        let label = UILabel()
        label.textColor = .black.withAlphaComponent(0.5)
        label.textAlignment = .left
        label.font = .regularFont.withSize(11)
        switch model.getPollStatus() {
        case .open:
            label.text = "Vote on this poll..."
            label.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(voteTapped))
            label.addGestureRecognizer(tapGesture)
        case .voted:
            label.text = "You've already voted on this poll."
        case .posted:
            label.text = "Your poll"
        }
        detailsStack.addArrangedSubview(label)
        // time label
        let time = UILabel()
        time.textAlignment = .right
        time.textColor = .black.withAlphaComponent(0.5)
        time.text = model.getTimeSincePost()
        time.font = .regularFont.withSize(11)
        detailsStack.addArrangedSubview(time)
        outerStack.addArrangedSubview(detailsStack)
    }
    
    @objc func voteTapped() {
        delegate?.voteTapped(poll: model)
    }
    
    override func prepareForReuse() {
        for subview in outerStack.arrangedSubviews {
            outerStack.removeArrangedSubview(subview)
            subview.removeFromSuperview()
        }
    }
}
