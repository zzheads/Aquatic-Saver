//
//  ViewController.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 27.08.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import UIKit
import Material

class LoginViewController: UIElements.ViewController, DefaultsLoadable {
    let store = UserDefaults.store
    var emailField = UIElements.textField("Email")
    var passwordField = UIElements.textField("Password", isPass: true)
    let loginButton = UIElements.raisedButton("Login")
    let registerButton = UIElements.flatButton("or Register new user")
    var rememberMeButton = UIElements.checkButton("remember me")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layout(self.rememberMeButton).center()
        self.view.layout(self.passwordField).left(32).right(32).center(offsetY: -48)
        self.view.layout(self.emailField).left(32).right(32).center(offsetY: -96)
        self.view.layout(self.loginButton).left(32).right(32).center(offsetY: 48)
        self.view.layout(self.registerButton).left(32).right(32).center(offsetY: 96)
        self.navigationItem.leftBarButtonItem = nil
        
        self.registerButton.addTarget(self, action: #selector(self.registerPressed(_:)), for: .touchUpInside)
        self.loginButton.addTarget(self, action: #selector(self.loginPressed(_:)), for: .touchUpInside)
        self.rememberMeButton.addTarget(self, action: #selector(self.rememberMeChanged(_:)), for: .touchUpInside)
        
        self.store?.load(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.rememberMeChanged(self.rememberMeButton)
    }
}

extension LoginViewController {
    @objc func registerPressed(_ sender: FlatButton) {
        self.performSegue(withIdentifier: Router.SegueID.toRegister.rawValue, sender: self)
    }
    
    @objc func loginPressed(_ sender: FlatButton) {
        guard let email = self.emailField.text, let password = self.passwordField.text, !email.isEmpty, !password.isEmpty else { return }
    }
    
    @objc func rememberMeChanged(_ sender: CheckButton) {
        if sender.isSelected { self.store?.save(self) } else { self.store?.clear() }
    }
}



