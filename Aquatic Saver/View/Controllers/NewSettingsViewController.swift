//
//  NewSettingsViewController.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 18.09.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import UIKit

class SettingsViewController: UIElements.ViewController {
    let settings: [SettingType] = [
        Setting<String>(key: "Server address", value: "http://132.187.56.45"),
        Setting<Bool>(key: "Lang", value: true),
        Setting<ArrayChoice>(key: "Language", value: ArrayChoice(array: ["Russian", "English", "French"], selected: 1))
    ]
    
    let rowBuilder1 = RowBuilder<Setting<String>, StringCell>(items: [Setting<String>(key: "Server address", value: "http://132.187.56.45")]) { setting in
        print("\(setting) modified!")
    }
    
    let rowBuilder2 = RowBuilder<Setting<ArrayChoice>, SegmentCell>(items: [Setting<ArrayChoice>(key: "Language", value: ArrayChoice(array: ["Russian", "English", "French"], selected: 1))]) { setting in
        print("\(setting) modified!")
    }
    
    lazy var director: TableViewDirector = {
        let director = TableViewDirector(tableView: self.tableView)
        return director
    }()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 40
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.view.backgroundColor = UIElements.Color.lightBlue
        self.view.addSubview(self.tableView)
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.saveSettings))
        self.navigationItem.rightBarButtonItem?.title = Translator.shared.translate("Save") as String
        UIElements.ViewController.setAttributes(for: [self.navigationItem.rightBarButtonItem])
        self.navigationItem.title = Translator.shared.translate("Settings") as String
        
        self.director.register(self.rowBuilder1)
        self.director.register(self.rowBuilder2)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    @objc func saveSettings() {
        self.navigationController?.popViewController(animated: true)
    }
}
