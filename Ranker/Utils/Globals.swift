//
//  Globals.swift
//  Ranker
//
//  Created by Shyam Kumar on 1/4/22.
//

import Foundation
import UIKit

let feedbackGenerator = UIImpactFeedbackGenerator(style: .medium)

func feedback() {
    feedbackGenerator.prepare()
    feedbackGenerator.impactOccurred()
}
