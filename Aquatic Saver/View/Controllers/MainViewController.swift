//
//  MainViewController.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 31.08.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import UIKit
import Material

class MainViewController: UIElements.ViewController {
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelId: UILabel!
    @IBOutlet weak var labelNumber: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelUpdated: UILabel!
    @IBOutlet weak var labelSOS1: UILabel!
    @IBOutlet weak var labelSOS2: UILabel!
    @IBOutlet weak var labelSOS3: UILabel!
    
    @IBOutlet weak var uniqueIdLabel: UILabel!
    @IBOutlet weak var simNumberLabel: UILabel!
    @IBOutlet weak var lastUpdatedLabel: UILabel!
    
    lazy var allLabels: [UILabel] = [self.labelName, self.labelId, self.labelNumber, self.labelStatus, self.labelUpdated, self.labelSOS1, self.labelSOS2, self.labelSOS3]
    
    enum TextFieldsKey: Int {
        case name = 3, model = 4, sos1 = 0, sos2 = 1, sos3 = 2
    }
    
    lazy var labels : [TextFieldsKey: UILabel] = [.name: self.labelName, .model: self.labelStatus, .sos1: self.labelSOS1, .sos2: self.labelSOS2, .sos3: self.labelSOS3]
    let textFields  : [TextFieldsKey: TextField] = [.name: UIElements.textField(), .sos1: UIElements.textField(), .sos2: UIElements.textField(), .sos3: UIElements.textField(), .model: UIElements.textField()]

    let buttons = [UIElements.raisedButton("Update"), UIElements.raisedButton("Delete", backColor: UIElements.Color.darkRed), UIElements.raisedButton("on Map"), UIElements.raisedButton("Register")]
    
    var device: Device? {
        didSet { self.configureView(self.device) }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.allLabels.forEach { $0.text = Translator.shared.translate($0.text) }
    
        self.textFields.forEach { self.view.addSubview($1) }
        self.textFields.forEach { key, textField in
            let label = labels[key]!
            NSLayoutConstraint.activate([
                textField.leftAnchor.constraint(equalTo: label.rightAnchor, constant: 16.0),
                textField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16.0),
                textField.centerYAnchor.constraint(equalTo: label.centerYAnchor)
                ])
            textField.font = UIElements.Font.medium(14.0)
        }
        
        var currentBottom: UIView = textFields[.sos3]!
        var currentMargin: CGFloat = 32.0
        self.buttons.forEach { button in
            self.view.addSubview(button)
            NSLayoutConstraint.activate([
                button.topAnchor.constraint(equalTo: currentBottom.bottomAnchor, constant: currentMargin),
                button.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 16.0),
                button.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -16.0),
                ])
            currentBottom = button
            currentMargin = 16.0
        }
        
        self.buttons[0].addTarget(self, action: #selector(self.updatePressed(_:)), for: .touchUpInside)
        self.buttons[1].addTarget(self, action: #selector(self.deletePressed(_:)), for: .touchUpInside)
        self.buttons[2].addTarget(self, action: #selector(self.onMapPressed(_:)), for: .touchUpInside)
        self.buttons[3].addTarget(self, action: #selector(self.registerPressed(_:)), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        APIClient.default.allDevices()
            .done{ self.device = $0.last }
            .catch{ self.showAlert(title: "Getting device error:", message: $0.localizedDescription, style: .alert) }
    }
    
    func setButtons(_ deviceIsNil: Bool) {
        self.buttons[2].isEnabled = deviceIsNil ? false : true
        self.buttons[2].backgroundColor = deviceIsNil ? UIElements.Color.darkBlue.withAlphaComponent(0.5) : UIElements.Color.darkBlue
        self.buttons[3].isEnabled = deviceIsNil ? true : false
        self.buttons[3].backgroundColor = deviceIsNil ? UIElements.Color.darkBlue : UIElements.Color.darkBlue.withAlphaComponent(0.5)
    }
    
    func configureView(_ device: Device?) {
        guard let device = device else {
            self.setButtons(true)
            return
        }
        self.setButtons(false)

        self.uniqueIdLabel.text = device.uniqueId
        self.simNumberLabel.text = device.phone
        self.lastUpdatedLabel.text = device.lastUpdate
        
        self.textFields[.name]?.text = "\(device.name ?? "") (\(device.status ?? .unknown))"
        self.textFields[.model]?.text = device.model
        if let sosNumbers = device.attributes?.sosNumbers {
            for i in 0..<sosNumbers.count {
                let key = TextFieldsKey(rawValue: i)!
                self.textFields[key]?.text = sosNumbers[i]
            }
        }
    }
    
    @objc func updatePressed(_ sender: RaisedButton) {
        guard let device = self.device else { return }
        var numbers = [String]()
        for key in [TextFieldsKey.sos1, .sos2, .sos3] {
            if let number = self.textFields[key]?.text, !number.isEmpty {
                numbers.append(number)
            }
        }
        device.name = self.textFields[.name]?.text
        device.model = self.textFields[.model]?.text
        device.attributes?.sosNumbers = numbers
        
        sender.isEnabled = false
        APIClient.default.update(device: device)
            .done { self.showAlert(title: "Update successfull:", message: "SOS numbers of device with id = \($0.uniqueId ?? "n/a") updated:\n\($0.attributes?.sosNumbers ?? [])", style: .alert) }
            .catch{ self.showAlert(title: "Updating device error:", message: $0.localizedDescription, style: .alert) }
            .finally { sender.isEnabled = true }
    }
    
    @objc func onMapPressed(_ sender: RaisedButton) {
        self.performSegue(withIdentifier: Router.SegueID.toMap.rawValue, sender: self)
    }
    
    @objc func deletePressed(_ sender: RaisedButton) {
        self.showAlertAndAsk(title: "Delete device", message: "Are you sure delete device?", style: .alert) { delete in
            guard let id = self.device?.id, delete else { return }
            sender.isEnabled = false
            APIClient.default.delete(id: id)
                .done { _ in self.showAlert(title: "Device deleted", message: "Device with id = \(id) deleted", style: .alert) }
                .catch{ self.showAlert(title: "Deleting device error:", message: $0.localizedDescription, style: .alert) }
                .finally { sender.isEnabled = true }
        }
    }

    @objc func registerPressed(_ sender: RaisedButton) {
        self.performSegue(withIdentifier: Router.SegueID.toRegisterDevice.rawValue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueId = segue.identifier else { return }
        if segueId == Router.SegueID.toMap.rawValue {
            let mapController = segue.destination as! MapViewController
            mapController.device = self.device
        }
    }
}

