//
//  SettingCell.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 29.08.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import UIKit

class StringCell: UITableViewCell, SettingConfigurableCell {
    static let identifier = "\(StringCell.self)"
    static let nib = UINib(nibName: identifier, bundle: nil)
    
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
 
    var setting: SettingType?
    var modify: ((SettingType?) -> Void)?
    
    func configure(with setting: SettingType, modify: ((SettingType?) -> Void)? = nil) {
        self.setting = setting
        self.modify = modify
        self.keyLabel.text = setting.key
        self.valueLabel.text = "\(setting.getValue())"
    }
}
