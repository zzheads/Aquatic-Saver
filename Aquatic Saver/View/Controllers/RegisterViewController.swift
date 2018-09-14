//
//  RegisterViewController.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 28.08.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import UIKit
import Material

class RegisterViewController: UIElements.ViewController {
    let usernameField = UIElements.textField("Username")
    let emailField = UIElements.textField("Email")
    let passwordField = UIElements.textField("Password")
    let registerButton = UIElements.raisedButton("Register")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layout(self.passwordField).center().left(32).right(32)
        self.view.layout(self.emailField).left(32).right(32).center(offsetY: -48)
        self.view.layout(self.usernameField).left(32).right(32).center(offsetY: -96)
        self.view.layout(self.registerButton).left(32).right(32).center(offsetY: 48)
        
        self.registerButton.addTarget(self, action: #selector(self.registerPressed(_:)), for: .touchUpInside)
    }
    
    @objc func registerPressed(_ sender: RaisedButton) {
        guard let username = self.usernameField.text, let email = self.emailField.text, let password = self.passwordField.text, !username.isEmpty, !email.isEmpty, !password.isEmpty else {
            self.showAlert(title: "Register user error:", message: "All fields must be filled", style: .alert)
            return
        }
        APIClient.default.register(username: username, email: email, password: password)
            .done{ self.showAlert(title: "User registered:", message: "id: \($0.id ?? 0),\nusername: \($0.name),\nemail: \($0.email),\npassword: \($0.password ?? "****")", style: .alert) }
            .catch{ self.showAlert(title: "Register user error:", message: $0.localizedDescription, style: .alert) }
    }
    
    
}
