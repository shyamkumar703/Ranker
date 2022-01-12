//
//  BarChart.swift
//  Ranker
//
//  Created by Shyam Kumar on 1/10/22.
//

import UIKit

@IBDesignable
class BarChart: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBInspectable var dataPoints: [Int] = [10, 20, 30, 40, 0] {
        didSet {
            goalReps = dataPoints.max() ?? 0
            collectionView.reloadData()
        }
    }
    var colors: [UIColor] = [.rBlue, .rRed]
    let cellReuseIdentifier = "BarCell"
    
    var goalLine: Bool = false
    var goalLineColor: UIColor = UIColor.purple
    
    var barWidth = 8
    
    var goalReps = 0
    
    lazy var layout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        return layout
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView: UICollectionView = UICollectionView(frame: bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(BarChartCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    override func draw(_ rect: CGRect) {
        if !goalLine {
            return
        }
        drawGoalDottedLine()
    }
    
    override func layoutSubviews() {
        addSubview(collectionView)
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        backgroundColor = .clear
    }
    
    func drawGoalDottedLine() {
        let path = UIBezierPath()
        goalLineColor.setStroke()
        let dashPattern: [CGFloat] = [2.0, 2.0]
        path.setLineDash(dashPattern, count: dashPattern.count, phase: 0)
        path.lineWidth = 1
        
        //EDGE INSET
        let totalWidth = 16 * dataPoints.count
        let leftInset = (frame.width - CGFloat(totalWidth)) / 2
        
        let endX = CGFloat(dataPoints.count * 16) + leftInset
        
        //CALCULATE Y VALUE
        //check the max between goal reps and the max of dataPoints. If goalReps is max, 4
        //else, 4 + (1 - goalReps/dataPoints.max()) * frame.height
        var endY: CGFloat = 4
        let maxDataRatio: CGFloat = CGFloat(goalReps) / CGFloat(dataPoints.max() ?? 0)
        if dataPoints.max() ?? 0 > goalReps {
            let inter = 1 - maxDataRatio
            endY = endY + inter * frame.height
        }
        
        path.move(to: CGPoint(x: leftInset, y: endY))
        path.addLine(to: CGPoint(x: endX, y: endY))
        path.stroke()
        
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.regularFont.withSize(8),
            .foregroundColor: goalLineColor,
        ]
        let attributedString = NSAttributedString(string: "GOAL REPS", attributes: attributes)
        let stringRect = CGRect(x: endX + 5, y: endY - 4, width: 100, height: 20)
        attributedString.draw(in: stringRect)
    }
    
    func reload() {
        collectionView.reloadData()
    }

}

extension BarChart {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataPoints.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier, for: indexPath) as? BarChartCell {
            cell.setupCell(dataPoint: dataPoints[indexPath.row], color: colors[indexPath.row % colors.count], barWidth: barWidth, maxDataPoint: dataPoints.max() ?? 1)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 16, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return centerItemsInCollectionView(cellWidth: 16, numberOfItems: Double(dataPoints.count), spaceBetweenCell: 0, collectionView: collectionView)
    }
    
    func centerItemsInCollectionView(cellWidth: Double, numberOfItems: Double, spaceBetweenCell: Double, collectionView: UICollectionView) -> UIEdgeInsets {
        let totalWidth = cellWidth * numberOfItems
        let totalSpacingWidth = spaceBetweenCell * (numberOfItems - 1)
        let leftInset = (collectionView.frame.width - CGFloat(totalWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset
        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }
}

class BarChartCell: UICollectionViewCell {
    
    var view: UIView = UIView()
    
    func setupCell(dataPoint: Int, color: UIColor, barWidth: Int, maxDataPoint: Int) {
        addSubview(view)
        view.backgroundColor = color
        view.layer.cornerRadius = 4
        view.removeConstraints(view.constraints)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: CGFloat(barWidth)).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        view.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        //HEIGHT ANCHOR
        let height = CGFloat(Double(dataPoint) / Double(maxDataPoint)) * (frame.height - 16)
        
        if dataPoint == 0 || (height < view.layer.cornerRadius * 2 + 2) {
            view.heightAnchor.constraint(equalToConstant: view.layer.cornerRadius * 2 + 2).isActive = true
        } else {
            view.heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
    override func prepareForReuse() {
        view.removeFromSuperview()
    }
}
