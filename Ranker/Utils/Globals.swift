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

protocol Reloadable {
    func reload(completion: @escaping () -> Void)
}

extension UIViewController {
    /// Call this once to dismiss open keyboards by tapping anywhere in the view controller
    func setupHideKeyboardOnTap() {
        self.view.addGestureRecognizer(self.endEditingRecognizer())
        self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
    }

    /// Dismisses the keyboard from self.view
    private func endEditingRecognizer() -> UIGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        tap.cancelsTouchesInView = false
        return tap
    }
}
