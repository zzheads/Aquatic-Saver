//
//  StringCell.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 18.09.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import UIKit

class ArrayCell: UITableViewCell, ConfigurableCell {
    @IBOutlet weak var labelKey: UILabel!
    @IBOutlet weak var fieldValue: UITextField!
    var item    : Setting<[String]>?
    var modify  : ((Setting<[String]>?) -> Void)?
    
    func configure(with item: Setting<[String]>, modify: ((Setting<[String]>?) -> Void)?) {
        self.item = item
        self.modify = modify
        self.labelKey.text = Translator.shared.translate(item.key) as String
        self.fieldValue.text = item.value?.description
        self.fieldValue.addTarget(self, action: #selector(self.textFieldPressed(_:)), for: .allEditingEvents)
    }
    
    func parse(_ string: String?) -> [String]? {
        guard var string = string else { return nil }
        string = string.replacingOccurrences(of: "[", with: "").replacingOccurrences(of: "]", with: "").replacingOccurrences(of: "\"", with: "")
        return string.split(separator: ",").map{ String($0) }
    }
    
    @objc func textFieldPressed(_ sender: UITextField) {
        self.item?.value = self.parse(sender.text)
        if let value = self.item?.value {
            print("New value: \(value)")
        }
        self.modify?(self.item)
    }
}
