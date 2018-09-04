//
//  SettingCell.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 29.08.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import UIKit

class SettingTypeCell: UITableViewCell, ConfigurableCell {
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var valueSwitch: UISwitch!
    
    var setting: SettingType?
    var modify: ((SettingType?) -> Void)?
    
    func configure(with item: SettingType, modify: ((SettingType?) -> Void)? = nil) {
        self.setting = item
        self.modify = modify
        self.keyLabel.text = item.key
        switch item.type {
        case .bool      :
            self.valueLabel.removeFromSuperview()
            self.valueSwitch.isOn = item.getValue() as! Bool
            self.valueSwitch.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
        case .string    :
            self.valueSwitch.removeFromSuperview()
            self.valueLabel.text = item.getValue() as? String
        case .int       :
            self.valueSwitch.removeFromSuperview()
            self.valueLabel.text = "\(item.getValue() as! Int)"
        case .double    :
            self.valueSwitch.removeFromSuperview()
            self.valueLabel.text = "\(item.getValue() as! Double)"
        case .array     :
            self.valueSwitch.removeFromSuperview()
            self.valueLabel.text = "\(item.getValue() as! [String])"
        }
    }
    
    @objc func switchChanged(_ sender: UISwitch) {
        self.setting?.setValue(sender.isOn)
        self.modify?(self.setting)
    }
}
