//
//  BoolCell.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 18.09.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import UIKit

class BoolCell: UITableViewCell, ConfigurableCell {
    @IBOutlet weak var labelKey: UILabel!
    @IBOutlet weak var switchValue: UISwitch!
    
    var item    : Setting<Bool>?
    var modify  : ((Setting<Bool>?) -> Void)?
    
    func configure(with item: Setting<Bool>, modify: ((Setting<Bool>?) -> Void)?) {
        self.item = item
        self.modify = modify
        self.labelKey.text = item.key
        self.switchValue.isOn = item.value ?? false
        self.switchValue.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
    }
    
    @objc func switchChanged(_ sender: UISwitch) {
        self.modify?(self.item)
    }
}
