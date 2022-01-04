//
//  Colors.swift
//  Ranker
//
//  Created by Shyam Kumar on 9/29/21.
//

import UIKit

extension UIColor {
    static var rRed: UIColor = UIColor(red:0.76, green:0.20, blue:0.20, alpha:1.0)
    static var rBlue: UIColor = UIColor(red:0.20, green:0.49, blue:0.76, alpha:1.0)
    static var rPink: UIColor = UIColor(red:0.76, green:0.20, blue:0.71, alpha:1.0)
    static var rPurple: UIColor = UIColor(red:0.27, green:0.20, blue:0.76, alpha:1.0)
    static var rTeal: UIColor = UIColor(red:0.20, green:0.66, blue:0.76, alpha:1.0)
    
    static func getColor(str: String) -> Color? {
        return Color(rawValue: str)
    }
}

enum Color: String {
    case red
    case blue
    case pink
    case purple
    case teal
    
    var color: UIColor {
        switch self {
        case .red:
            return .rRed
        case .blue:
            return .rBlue
        case .pink:
            return .rPink
        case .purple:
            return .rPurple
        case .teal:
            return .rTeal
        }
    }
}
