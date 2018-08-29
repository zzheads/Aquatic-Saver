//
//  BoolCell.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 29.08.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import UIKit

class BoolCell: UITableViewCell {
    static let identifier = "\(BoolCell.self)"
    static let nib = UINib(nibName: identifier, bundle: nil)
    
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueSwitch: UISwitch!
    
    func configure(with setting: SettingType) {
        self.keyLabel.text = setting.key
        self.valueSwitch.isOn = setting.getValue() as? Bool ?? false
    }
}
