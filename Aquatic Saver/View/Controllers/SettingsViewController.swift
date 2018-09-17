//
//  SettingsViewController.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 29.08.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import UIKit

class SettingsViewController: UIElements.ViewController {
    lazy var dataSource: DataSource<SettingType, SettingTypeCell> = {
        return DataSource<SettingType, SettingTypeCell>(Settings.shared) { setting in
            if let setting = setting {
                Settings.shared.update(setting)
                if setting.key == "Language" {
                    self.showAlertAndAsk(title: Translator.shared.translate("Language"), message: Translator.shared.translate("Changes will take effect after reload app"), style: .alert) { reload in
                        if reload { UIApplication.shared.keyWindow?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() }
                    }
                }
            }
        }
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(SettingTypeCell.nib, forCellReuseIdentifier: SettingTypeCell.identifier)
        tableView.rowHeight = 40
        tableView.dataSource = self.dataSource
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    @objc func saveSettings() {
        self.navigationController?.popViewController(animated: true)
    }
}
