//
//  MainViewController.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 31.08.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import UIKit
import Material
import PhoneNumberKit

class MainViewController: UIElements.ViewController {
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelUniqueId: UILabel!
    @IBOutlet weak var labelSimNumber: UILabel!
    @IBOutlet weak var labelModel: UILabel!
    @IBOutlet weak var labelLastUpdated: UILabel!
    @IBOutlet weak var labelSOS1: UILabel!
    @IBOutlet weak var labelSOS2: UILabel!
    @IBOutlet weak var labelSOS3: UILabel!
    @IBOutlet weak var valueStatus: UILabel!
    @IBOutlet weak var valueName: UILabel!
    @IBOutlet weak var valueId: UILabel!
    @IBOutlet weak var valueNumber: UILabel!
    @IBOutlet weak var valueModel: UILabel!
    @IBOutlet weak var valueUpdated: UILabel!
    
    lazy var allLabels: [UILabel] = [self.labelStatus, self.labelName, self.labelUniqueId, self.labelSimNumber, self.labelModel, self.labelLastUpdated, self.labelSOS1, self.labelSOS2, self.labelSOS3]
    
    enum TextFieldsKey: Int {
        case sos1 = 0, sos2 = 1, sos3 = 2
    }
    
    lazy var labels : [TextFieldsKey: UILabel] = [.sos1: self.labelSOS1, .sos2: self.labelSOS2, .sos3: self.labelSOS3]
    lazy var textFields  : [TextFieldsKey: PhoneNumberTextField] = [.sos1: UIElements.phoneField(font: UIElements.Font.medium(14.0)), .sos2: UIElements.phoneField(font: UIElements.Font.medium(14.0)), .sos3: UIElements.phoneField(font: UIElements.Font.medium(14.0))]

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
            .done{ devices in
                self.device = devices.last
                if let device = self.device {
                    APIClient.default.events([device.id!])
                        .done { events in
                            events.forEach { print("\($0.serverTime!.localDate): \($0.description),") }
                        }
                        .catch { print($0) }
                }
            }
            .catch{ self.showAlert(title: "Getting device error:", message: $0.localizedDescription, style: .alert) }
    }
    
    func setButtons(_ device: Device?) {
        self.buttons[0].isEnabled = (device?.status == DeviceStatus.online)
        self.buttons[0].backgroundColor = (device?.status == DeviceStatus.online) ? UIElements.Color.darkBlue : UIElements.Color.darkBlue.withAlphaComponent(0.5)
        self.buttons[2].isEnabled = (device == nil) ? false : true
        self.buttons[2].backgroundColor = (device == nil) ? UIElements.Color.darkBlue.withAlphaComponent(0.5) : UIElements.Color.darkBlue
        self.buttons[3].isEnabled = (device == nil) ? true : false
        self.buttons[3].backgroundColor = (device == nil) ? UIElements.Color.darkBlue : UIElements.Color.darkBlue.withAlphaComponent(0.5)
    }
    
    func configureView(_ device: Device?) {
        self.setButtons(device)

        self.valueStatus.text = Translator.shared.translate("\(device?.status ?? .unknown)") as String
        self.valueStatus.textColor = device?.markerColor ?? UIElements.Color.darkBlue
        self.valueName.text = device?.name
        self.valueId.text = device?.uniqueId
        self.valueNumber.text = device?.phone
        self.valueModel.text = device?.model
        self.valueUpdated.text = device?.lastUpdate?.localDate
        
        if let sosNumbers = device?.attributes?.sosNumbers {
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

extension MainViewController: ObjectsObservable {
    func socketDidReceived(_ devices: [Device]) {
        self.device = devices.first
        self.configureView(self.device)
    }
}

