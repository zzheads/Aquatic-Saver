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
    }
}
