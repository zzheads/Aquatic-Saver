//
//  RowBuilder.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 18.09.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import UIKit

protocol RowBuilderType {
    var itemsCount: Int { get }
    var identifier: String { get }
    var nib : UINib { get }
    var id: UUID { get }
    func configure(cell: UITableViewCell, at indexPath: IndexPath)
}

class RowBuilder<Type, Cell: ConfigurableCell>: RowBuilderType where Cell.ItemType == Type {
    internal let id     : UUID
    private var items   : [Type]
    private var modify  : ((Type?) -> Void)?
    
    public var itemsCount: Int {
        return self.items.count
    }
    
    public var identifier: String {
        return Cell.identifier
    }
    
    public var nib: UINib {
        return Cell.nib
    }
    
    init(items: [Type] = [], modify: ((Type?) -> Void)? = nil) {
        self.id = UUID()
        self.items = items
        self.modify = modify
    }
    
    func configure(cell: UITableViewCell, at indexPath: IndexPath) {
        let cell = cell as! Cell
        let item = items[indexPath.row]
        cell.configure(with: item, modify: self.modify)
    }
}
