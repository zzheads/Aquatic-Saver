//
//  ConfigurableCell.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 31.08.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import UIKit

protocol ConfigurableCell {
    associatedtype Object
    static var identifier   : String { get }
    static var nib          : UINib { get }
    func configure(with object: Object, modify: ((Object) -> Void)?)
}
