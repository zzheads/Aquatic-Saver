//
//  DataSource.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 04.09.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import UIKit

class DataSource<Type, Cell: ConfigurableCell>: NSObject, UITableViewDataSource where Cell.ItemType == Type {
    var items       : [Type]
    var modify      : ((Type?) -> Void)?
    
    init(_ items: [Type] = [], modify: ((Type?) -> Void)? = nil) {
        self.items = items
        self.modify = modify
        super.init()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cell.identifier, for: indexPath) as! Cell
        cell.configure(with: self.items[indexPath.row], modify: self.modify)
        return cell as! UITableViewCell
    }
}
