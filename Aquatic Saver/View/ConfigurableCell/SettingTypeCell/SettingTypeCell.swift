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
        self.keyLabel.text = Translator.shared.translate(item.key) as String
        self.valueSwitch.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
        if item.type == .bool { self.valueLabel.removeFromSuperview() } else { self.valueSwitch.removeFromSuperview() }
        switch item.type {
        case .bool      : self.valueSwitch.isOn = item.getValue() as! Bool
        case .string    : self.valueLabel.text = item.getValue() as? String
        case .int       : self.valueLabel.text = "\(item.getValue() as! Int)"
        case .double    : self.valueLabel.text = "\(item.getValue() as! Double)"
        case .array     : self.valueLabel.text = "\(item.getValue() as! [String])"
        }
    }
    
    @objc func switchChanged(_ sender: UISwitch) {
        self.setting?.setValue(sender.isOn)
        self.modify?(self.setting)
    }
}
