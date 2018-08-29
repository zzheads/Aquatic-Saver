//
//  SettingsViewController.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 29.08.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import UIKit

class SettingsViewController: UIElements.ViewController {
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(StringCell.nib, forCellReuseIdentifier: StringCell.identifier)
        tableView.register(BoolCell.nib, forCellReuseIdentifier: BoolCell.identifier)
        tableView.rowHeight = 40
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    let settings: [SettingType] = [
        Setting(key: "Server address", value: "132.197.0.34:8080"),
        Setting(key: "Maximum connections", value: 10),
        Setting(key: "Remember password", value: true),
        Setting(key: "Supported devices", value: ["KVZ-612", "KVZ-302", "KVZ-111"])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.view.backgroundColor = UIElements.AppColor.lightBlue
        self.view.addSubview(self.tableView)
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.topLayoutGuide.topAnchor),
            self.tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            self.tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.saveSettings))
        UIElements.ViewController.setAttributes(for: [self.navigationItem.rightBarButtonItem])
        self.navigationItem.title = "Settings"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    @objc func saveSettings() {
        print("Settings saved")
        self.navigationController?.popViewController(animated: true)
    }
}

extension SettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let setting = self.settings[indexPath.row]
        if setting.cellType == .bool {
            let cell = tableView.dequeueReusableCell(withIdentifier: BoolCell.identifier, for: indexPath) as! BoolCell
            cell.configure(with: setting)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: StringCell.identifier, for: indexPath) as! StringCell
            cell.configure(with: setting)
            return cell
        }
    }
}
