//
//  ConfigurableCell.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 31.08.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import UIKit

public protocol ConfigurableCell {
    static var identifier   : String { get }
    static var nib          : UINib { get }
    
    associatedtype ItemType
    
    func configure(with item: ItemType, modify: ((ItemType?) -> Void)?)
}

public extension ConfigurableCell {
    public static var identifier: String { return String(describing: Self.self) }
    public static var nib       : UINib { return UINib(nibName: identifier, bundle: nil) }
}


