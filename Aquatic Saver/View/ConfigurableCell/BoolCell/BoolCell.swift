//
//  BoolCell.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 29.08.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import UIKit

protocol SettingConfigurableCell {
    var setting : SettingType? { get set }
    var modify  : ((SettingType?) -> Void)? { get set }
    
    func configure(with setting: SettingType, modify: ((SettingType?) -> Void)?)
}

class BoolCell: UITableViewCell, SettingConfigurableCell {
    static let identifier = "\(BoolCell.self)"
    static let nib = UINib(nibName: identifier, bundle: nil)
    
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueSwitch: UISwitch!
    
    var setting: SettingType?
    var modify: ((SettingType?) -> Void)?
    
    func configure(with setting: SettingType, modify: ((SettingType?) -> Void)? = nil) {
        self.setting = setting
        self.modify = modify
        self.keyLabel.text = setting.key
        self.valueSwitch.isOn = setting.getValue() as? Bool ?? false
        self.valueSwitch.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
    }
    
    @objc func switchChanged(_ sender: UISwitch) {
        self.setting?.setValue(sender.isOn)
        self.modify?(self.setting)
    }
}
