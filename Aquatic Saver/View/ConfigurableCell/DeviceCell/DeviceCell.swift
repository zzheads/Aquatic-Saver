//
//  DeviceCell.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 31.08.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import UIKit

class DeviceCell: UITableViewCell, ConfigurableCell {
    static let identifier = "\(DeviceCell.self)"
    static let nib = UINib(nibName: identifier, bundle: nil)

    @IBOutlet weak var deviceView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var batteryLabel: UILabel!
    var device: Device?
    var modify: ((Device) -> Void)?
    
    func configure(with object: Device, modify: ((Device) -> Void)?) {
        dump(object)
        self.device = object
        self.modify = modify
        if let data = object.photo {
            self.deviceView.image = UIImage(data: data)
        } else {
            self.deviceView.image = #imageLiteral(resourceName: "device")
        }
        if let name = object.name {
            if let uniqueId = object.uniqueId {
                self.nameLabel.text = "\(name) (\(uniqueId))"
            } else {
                self.nameLabel.text = name
            }
        }
        if let model = object.model {
            self.modelLabel.text = model
        }
        if let battery = object.attributes?.battery {
            self.batteryLabel.text = "\(battery)"
        } else {
            self.batteryLabel.text = "n/a"
        }
    }
}
