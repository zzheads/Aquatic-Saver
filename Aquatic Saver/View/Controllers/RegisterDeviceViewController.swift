//
//  RegisterDeviceViewController.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 31.08.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import UIKit
import Material

class RegisterDeviceViewController: UIElements.ViewController {
    let imeiField = UIElements.textField("ID or IMEI")
    let numberField = UIElements.textField("SIM number")
    let nameField = UIElements.textField("Name of device")
    let registerButton = UIElements.raisedButton("Register device")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layout(self.nameField).left(32).right(32).center()
        self.view.layout(self.numberField).left(32).right(32).center(offsetY: -48)
        self.view.layout(self.imeiField).left(32).right(32).center(offsetY: -96)
        self.view.layout(self.registerButton).left(32).right(32).center(offsetY: 48)
        
        self.registerButton.addTarget(self, action: #selector(self.registerPressed(_:)), for: .touchUpInside)
    }
}

extension RegisterDeviceViewController {
    @objc func registerPressed(_ sender: RaisedButton) {
        guard let imei = self.imeiField.text, let number = self.numberField.text, let name = self.nameField.text, !imei.isEmpty, !number.isEmpty, !name.isEmpty else { return }
        APIClient.default.addDevice(imei: imei, phone: number, name: name)
            .done { self.showAlert(title: "Device added", message: "\($0.toJSON)", style: .alert) }
            .catch { self.showAlert(title: "Adding device error", message: $0.localizedDescription, style: .alert)}
    }
}
