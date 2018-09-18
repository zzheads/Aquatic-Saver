//
//  NewSettingsViewController.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 18.09.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import UIKit

class SettingsViewController: UIElements.ViewController {
    
    let rowBuilder1 = RowBuilder<Setting<String>, StringCell>(items: [Settings.baseUrl]) { setting in
        guard let value = setting?.value else { return }
        Settings.baseUrl.value = value
    }
    
    let rowBuilder2 = RowBuilder<Setting<ArrayChoice>, SegmentCell>(items: [Settings.language]) { setting in
        guard let value = setting?.value else { return }
        Settings.language.value = value
    }
    
    let rowBuilder3 = RowBuilder<Setting<[String]>, ArrayCell>(items: [Settings.devices]) { setting in
        guard let value = setting?.value else { return }
        Settings.devices.value = value
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
        tableView.allowsSelection = false
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.view.backgroundColor = UIElements.Color.lightBlue
        self.view.addSubview(self.tableView)
        self.tableView.backgroundColor = .clear

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
        self.director.register(self.rowBuilder3)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Settings.load()
        self.tableView.reloadData()
    }
    
    @objc func saveSettings() {
        let languageChanged = Settings.language.value?.selection != UserDefaults.store?.language?.selection
        Settings.save()
        if languageChanged {
            self.showAlertAndAsk(title: "Language switch", message: "Changes will take effect after reload app", style: .alert) { reload in
                if reload { UIApplication.shared.keyWindow?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() }
                else { self.navigationController?.popViewController(animated: true) }
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
}
