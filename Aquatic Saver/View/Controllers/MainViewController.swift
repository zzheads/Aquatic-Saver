//
//  MainViewController.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 31.08.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import UIKit

class MainViewController: UIElements.ViewController {
    
    @IBOutlet weak var deviceLabel: UILabel!
    @IBOutlet weak var sosOneField: UITextField!
    @IBOutlet weak var sosTwoFIeld: UITextField!
    @IBOutlet weak var sosThreeField: UITextField!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var onMapButton: UIButton!
    
    var textFields: [UITextField] {
        return [self.sosOneField, self.sosTwoFIeld, self.sosThreeField]
    }
    
    var device: Device? {
        didSet { self.updateInfo(self.device) }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateButton.addTarget(self, action: #selector(self.updateSosNumbers(_:)), for: .touchUpInside)
        self.onMapButton.addTarget(self, action: #selector(self.onMapPressed(_:)), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        APIClient.default.allDevices()
            .done{ self.device = $0.last }
            .catch{ self.showAlert(title: "Getting device error:", message: $0.localizedDescription, style: .alert) }
    }
    
    func updateInfo(_ device: Device?) {
        guard let device = device else {
            self.performSegue(withIdentifier: Router.SegueID.toRegisterDevice.rawValue, sender: self)
            self.onMapButton.isEnabled = false
            return
        }
        self.onMapButton.isEnabled = true
        self.deviceLabel.text = device.onMapDescription
        if let sosNumbers = device.attributes?.sosNumbers {
            for i in 0..<sosNumbers.count {
                self.textFields[i].text = sosNumbers[i]
            }
        }
    }
    
    @objc func updateSosNumbers(_ sender: UIButton) {
        guard let device = self.device else { return }
        var numbers = [String]()
        for field in self.textFields {
            if let number = field.text, !number.isEmpty {
                numbers.append(number)
            }
        }
        if !numbers.isEmpty {
            sender.isEnabled = false
            device.attributes?.sosNumbers = numbers
            APIClient.default.update(device: device)
                .done { self.showAlert(title: "Update successfull:", message: "SOS numbers of device with id = \($0.uniqueId ?? "n/a") updated:\n\($0.attributes?.sosNumbers ?? [])", style: .alert) }
                .catch{ self.showAlert(title: "Updating device error:", message: $0.localizedDescription, style: .alert) }
                .finally { sender.isEnabled = true }
        }
    }
    
    @objc func onMapPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: Router.SegueID.toMap.rawValue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueId = segue.identifier else { return }
        if segueId == Router.SegueID.toMap.rawValue {
            let mapController = segue.destination as! MapViewController
            mapController.device = self.device
        }
    }
}

