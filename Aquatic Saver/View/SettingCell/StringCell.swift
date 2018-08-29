//
//  SettingCell.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 29.08.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import UIKit

class StringCell: UITableViewCell {
    static let identifier = "\(StringCell.self)"
    static let nib = UINib(nibName: identifier, bundle: nil)
    
    @IBOutlet weak var keyLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
 
    var setting: SettingType?
    var modify: ((SettingType) -> Void)?
    
    func configure(with setting: SettingType) {
        self.keyLabel.text = setting.key
        self.valueLabel.text = "\(setting.getValue())"
    }
}
