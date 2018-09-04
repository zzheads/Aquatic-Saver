//
//  DeviceCell.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 31.08.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import UIKit

class DeviceCell: UITableViewCell, ConfigurableCell {
    @IBOutlet weak var deviceView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var batteryLabel: UILabel!
    var device: Device?
    var modify: ((Device) -> Void)?
    
    func configure(with item: Device, modify: ((Device?) -> Void)?) {
        dump(item)
        self.device = item
        self.modify = modify
        if let data = item.photo {
            self.deviceView.image = UIImage(data: data)
        } else {
            self.deviceView.image = #imageLiteral(resourceName: "device")
        }
        if let name = item.name {
            if let uniqueId = item.uniqueId {
                self.nameLabel.text = "\(name) (\(uniqueId))"
            } else {
                self.nameLabel.text = name
            }
        }
        if let model = item.model {
            self.modelLabel.text = model
        }
        if let battery = item.attributes?.battery {
            self.batteryLabel.text = "\(battery)"
        } else {
            self.batteryLabel.text = "n/a"
        }
    }
}
