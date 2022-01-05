//
//  VoteViewController.swift
//  Ranker
//
//  Created by Shyam Kumar on 1/4/22.
//

import UIKit

struct VoteViewControllerModel {
    var poll: Poll
    var vote: Vote
    init?(poll: Poll = Poll()) {
        self.poll = poll
        if poll.choices.count == 0 { return nil }
        if let uid = uid {
            var data: [String: PollChoice] = [:]
            for i in 0..<poll.choices.count {
                let choice = poll.choices[i]
                data[String(i)] = choice
            }
            vote = Vote(id: uid, data: data)
        } else {
            return nil
        }
    }
}

class VoteViewController: UIViewController {
    
    var model = VoteViewControllerModel() {
        didSet {
            updateView()
        }
    }
    
    lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        return label
    }()
    
    lazy var rankTableView: RankTableView = {
        let view = RankTableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var pab: PrimaryActionButton = {
        let pab = PrimaryActionButton()
        pab.title = "Vote"
        pab.delegate = self
        pab.translatesAutoresizingMaskIntoConstraints = false
        return pab
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(questionLabel)
        view.addSubview(rankTableView)
        view.addSubview(pab)
    }
    
    func setupConstraints() {
        questionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        questionLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        questionLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        
        rankTableView.topAnchor.constraint(equalTo: questionLabel.bottomAnchor, constant: 24).isActive = true
        rankTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        rankTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        rankTableView.bottomAnchor.constraint(equalTo: pab.topAnchor).isActive = true
        
        pab.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        pab.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        pab.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
        pab.heightAnchor.constraint(equalToConstant: 36).isActive = true
        pab.layer.cornerRadius = 10
    }
    
    func updateView() {
        if let question = model?.poll.question {
            let standardAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.regularFont.withSize(15), .foregroundColor: UIColor.black.withAlphaComponent(0.5)]
            let questionAttributes: [NSAttributedString.Key: Any] = [.font: UIFont.regularFont.withSize(15), .foregroundColor: UIColor.black]
            let attrString = NSMutableAttributedString(string: "Someone wants to know\n", attributes: standardAttributes)
            let questionAttr = NSMutableAttributedString(string: "\(question)", attributes: questionAttributes)
            attrString.append(questionAttr)
            questionLabel.attributedText = attrString
        }
        rankTableView.model = model?.vote
    }
}

extension VoteViewController: TapHandler {
    var handleTap: Selector {
        return #selector(tapHandler)
    }
    
    @objc func tapHandler() {
        if let vote = rankTableView.model {
            model?.poll.addVote(vote: vote)
            feedback()
            if let vc = presentingViewController as? Reloadable {
                vc.reload {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}
