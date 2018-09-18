//
//  SegmentCell.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 18.09.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import UIKit

struct ArrayChoice: Codable {
    let array       : [String]
    var selected    : Int
    
    var selection   : String {
        return self.array[self.selected]
    }
}

extension ArrayChoice: CustomStringConvertible {
    var description: String {
        return "array: \(self.array), selected: \(self.selected)"
    }
}

class SegmentCell: UITableViewCell, ConfigurableCell {
    @IBOutlet weak var labelKey: UILabel!
    @IBOutlet weak var segmentValue: UISegmentedControl!
    
    var item    : Setting<ArrayChoice>?
    var modify  : ((Setting<ArrayChoice>?) -> Void)?
    
    func configure(with item: Setting<ArrayChoice>, modify: ((Setting<ArrayChoice>?) -> Void)?) {
        self.backgroundColor = .clear
        self.item = item
        self.modify = modify
        self.labelKey.text = Translator.shared.translate(item.key) as String
        self.segmentValue.removeAllSegments()
        guard let array = item.value?.array, let selected = item.value?.selected else { return }
        for i in 0..<array.count {
            self.segmentValue.insertSegment(withTitle: array[i], at: i, animated: true)
        }
        self.segmentValue.selectedSegmentIndex = selected
        self.segmentValue.addTarget(self, action: #selector(self.segmentChanged(_:)), for: .valueChanged)
    }
    
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        self.item?.value?.selected = sender.selectedSegmentIndex
        self.modify?(self.item)
    }
}
