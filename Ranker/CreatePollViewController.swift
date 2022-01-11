//
//  CreatePollViewController.swift
//  Ranker
//
//  Created by Shyam Kumar on 1/4/22.
//

import FirebaseFirestore
import UIKit

// TODO: - Handle keyboard stuff

class CreatePollViewController: UIViewController {
    
    var keyboardHeightLayoutConstraint: NSLayoutConstraint?
    
    lazy var titleTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "How do you rank..."
        field.font = .regularFont.withSize(18)
        field.textColor = .black
        field.translatesAutoresizingMaskIntoConstraints = false
        field.adjustsFontSizeToFitWidth = true
        field.delegate = self
        return field
    }()
    
    lazy var table: CreatePollTableView = {
        let view = CreatePollTableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var pab: PrimaryActionButton = {
        let pab = PrimaryActionButton()
        pab.delegate = self
        pab.title = "Post"
        pab.translatesAutoresizingMaskIntoConstraints = false
        return pab
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        titleTextField.becomeFirstResponder()
    }
    
    func setupView() {
        view.backgroundColor = .white
        view.addSubview(titleTextField)
        view.addSubview(table)
        view.addSubview(pab)
        setupHideKeyboardOnTap()
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.keyboardNotification(notification:)),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }
    
    func setupConstraints() {
        titleTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 32).isActive = true
        titleTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        titleTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        
        table.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 8).isActive = true
        table.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        table.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        table.bottomAnchor.constraint(equalTo: pab.topAnchor).isActive = true
        
        pab.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        pab.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        pab.heightAnchor.constraint(equalToConstant: 36).isActive = true
        pab.layer.cornerRadius = 10
        
        keyboardHeightLayoutConstraint = pab.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8)
        keyboardHeightLayoutConstraint?.isActive = true
    }
    
    func updateView() {
    }
    
    @objc func keyboardNotification(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        
        let endFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        let endFrameY = endFrame?.origin.y ?? 0
        let duration: TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
        
        if endFrameY >= UIScreen.main.bounds.size.height {
            keyboardHeightLayoutConstraint?.constant = -8
        } else {
            keyboardHeightLayoutConstraint?.constant = (-1 * (endFrame?.size.height ?? 0)) - 4
        }
        
        UIView.animateKeyframes(
            withDuration: duration,
            delay: 0,
            animations: {
                self.view.layoutIfNeeded()
            },
            completion: nil
        )
    }
}

extension CreatePollViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let text = textField.text else { return }
        guard let model = table.model else { return }
        model.question = text
    }
}

extension CreatePollViewController: TapHandler {
    var handleTap: Selector {
        return #selector(handlePabTap)
    }
    
    @objc func handlePabTap() {
        guard let model = table.model else { return }
        model.choices = model.choices.filter({ !$0.title.isEmpty })
        if model.choices.count == 0 {
            // TODO: - HANDLE HERE
        }
        feedback()
        let db = Firestore.firestore()
        db.add(collectionName: .polls, object: model, completion: { [self] in
            if let vc = presentingViewController as? Reloadable {
                vc.reload {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        })
    }
}
