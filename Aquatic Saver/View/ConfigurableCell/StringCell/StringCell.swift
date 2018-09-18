//
//  StringCell.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 18.09.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import UIKit

class StringCell: UITableViewCell, ConfigurableCell {
    @IBOutlet weak var labelKey: UILabel!
    @IBOutlet weak var fieldValue: UITextField!
    var item    : Setting<String>?
    var modify  : ((Setting<String>?) -> Void)?
    
    func configure(with item: Setting<String>, modify: ((Setting<String>?) -> Void)?) {
        self.item = item
        self.modify = modify
        self.labelKey.text = Translator.shared.translate(item.key) as String
        self.fieldValue.text = item.value
        self.fieldValue.addTarget(self, action: #selector(self.textFieldPressed(_:)), for: .allEditingEvents)
    }
    
    @objc func textFieldPressed(_ sender: UITextField) {
        self.item?.value = sender.text
        self.modify?(self.item)
    }
}
