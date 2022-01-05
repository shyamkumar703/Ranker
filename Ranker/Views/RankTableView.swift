//
//  RankTableView.swift
//  Ranker
//
//  Created by Shyam Kumar on 1/4/22.
//

import UIKit

fileprivate var cellId: String = "rank"

class RankTableView: UIView {
    
    var model = Vote() {
        didSet {
            updateView()
        }
    }
    
    lazy var headerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 25))
        view.backgroundColor = .clear
        
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black.withAlphaComponent(0.5)
        label.font = .regularFont.withSize(12)
        label.text = "Rank these choices in your preferred order."
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        label.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        label.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.dragInteractionEnabled = true
        tv.delegate = self
        tv.dataSource = self
        tv.register(RankTableViewCell.self, forCellReuseIdentifier: cellId)
        tv.backgroundColor = .white
        tv.showsVerticalScrollIndicator = false
        tv.tableHeaderView = headerView
        tv.isEditing = true
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
        tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    }
    
    func updateView() {
        tableView.reloadData()
    }
}

extension RankTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model?.data.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? RankTableViewCell {
            if let cellModel = model?.data[String(indexPath.row)] {
                cell.model = cellModel
                cell.selectionStyle = .none
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let sourceModel = model?.data[String(sourceIndexPath.row)] else { return }
        var newData: [String: PollChoice] = [String(destinationIndexPath.row): sourceModel]
        if sourceIndexPath.row < destinationIndexPath.row {
            for i in (sourceIndexPath.row + 1)..<(destinationIndexPath.row + 1) {
                newData[String(i - 1)] = model?.data[String(i)]
            }
        } else {
            for i in (destinationIndexPath.row)..<(sourceIndexPath.row) {
                newData[String(i + 1)] = model?.data[String(i)]
            }
        }
        if let data = model?.data {
            for (key, val) in data {
                if !newData.keys.contains(key) {
                    newData[key] = val
                }
            }
        }
        model?.data = newData
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
}

class RankTableViewCell: UITableViewCell {
    
    let circleDim: CGFloat = 12
    
    var model: PollChoice? {
        didSet {
            updateView()
        }
    }
    
    lazy var circleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: circleDim).isActive = true
        view.widthAnchor.constraint(equalToConstant: circleDim).isActive = true
        view.layer.cornerRadius = circleDim / 2
        return view
    }()
    
    lazy var choiceName: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .regularFont.withSize(12)
        label.textColor = .black
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
        contentView.addSubview(circleView)
        contentView.addSubview(choiceName)
    }
    
    func setupConstraints() {
        circleView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 8).isActive = true
        circleView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        choiceName.leftAnchor.constraint(equalTo: circleView.rightAnchor, constant: 8).isActive = true
        choiceName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        choiceName.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -8).isActive = true
    }
    
    func updateView() {
        if let color = UIColor.getColor(str: model?.color ?? "")?.color {
            circleView.backgroundColor = color
        }
        choiceName.text = model?.title
    }
}
