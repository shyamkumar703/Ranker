//
//  FeedTableView.swift
//  Ranker
//
//  Created by Shyam Kumar on 9/30/21.
//

import UIKit

struct FeedTableViewModel {
    var cells: [PollViewModel]
    
    init(cells: [PollViewModel] = []) {
        self.cells = cells
    }
}

class FeedTableView: UIView {
    
    let cellId: String = "poll"
    
    var model: FeedTableViewModel = FeedTableViewModel() {
        didSet {
            updateView()
        }
    }
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.delegate = self
        tv.dataSource = self
        tv.register(FeedTableViewCell.self, forCellReuseIdentifier: cellId)
        tv.separatorStyle = .none
        tv.translatesAutoresizingMaskIntoConstraints = false
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
}

extension FeedTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.cells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as? FeedTableViewCell {
            cell.model = model.cells[indexPath.row]
            return cell
        }
        return UITableViewCell()
    }
}


class FeedTableViewCell: UITableViewCell {
    
    var model: PollViewModel = PollViewModel() {
        didSet {
            updateView()
        }
    }
    
    lazy var poll: PollView = {
        let view = PollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        contentView.addSubview(poll)
        contentView.isUserInteractionEnabled = true
    }
    
    func setupConstraints() {
        poll.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        poll.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
        poll.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        poll.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
    }
    
    func updateView() {
        poll.model = model
    }
}
