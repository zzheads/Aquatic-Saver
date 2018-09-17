//
//  TableViewDirector.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 18.09.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import UIKit

class TableViewDirector: NSObject {
    private var builders    : [RowBuilderType]
    private let tableView   : UITableView
    
    init(tableView: UITableView) {
        self.builders = []
        self.tableView = tableView
        super.init()
        self.tableView.dataSource = self
    }
    
    var totalItems: Int {
        return self.builders.compactMap{$0.itemsCount}.reduce(0, +)
    }
    
    func builderFor(indexPath: IndexPath) -> RowBuilderType? {
        var countItems = 0
        for builder in self.builders {
            if indexPath.row < countItems + builder.itemsCount { return builder }
            countItems += builder.itemsCount
        }
        return nil
    }
    
    func indexPath(_ indexPath: IndexPath, builder: RowBuilderType) -> IndexPath {
        var result = indexPath.row
        for current in self.builders {
            if current.id == builder.id { break }
            result -= current.itemsCount
        }
        return IndexPath(row: result, section: 0)
    }
    
    func register(_ builder: RowBuilderType) {
        self.builders.append(builder)
        self.tableView.register(builder.nib, forCellReuseIdentifier: builder.identifier)
    }
}

extension TableViewDirector: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.totalItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let builder = self.builderFor(indexPath: indexPath)!
        let internalIndexPath = self.indexPath(indexPath, builder: builder)
        let cell = tableView.dequeueReusableCell(withIdentifier: builder.identifier, for: indexPath)
        builder.configure(cell: cell, at: internalIndexPath)
        return cell
    }
}
