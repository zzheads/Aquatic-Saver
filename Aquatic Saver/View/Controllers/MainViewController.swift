//
//  MainViewController.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 31.08.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import UIKit

class MainViewController: UIElements.ViewController {
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(DeviceCell.nib, forCellReuseIdentifier: DeviceCell.identifier)
        tableView.rowHeight = 40
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    var devices: [Device] = []

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
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.addPressed(_:)))
        UIElements.ViewController.setAttributes(for: [self.navigationItem.rightBarButtonItem])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        APIClient.default.allDevices()
            .done{ devices in
                self.devices = devices
                self.tableView.reloadData()
            }
            .catch{ print($0) }
            .finally {
                if self.devices.count == 0 {
                    self.performSegue(withIdentifier: Router.SegueID.toRegisterDevice.rawValue, sender: self)
                }
            }

    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.devices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DeviceCell.identifier, for: indexPath) as! DeviceCell
        cell.configure(with: self.devices[indexPath.row], modify: nil)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: Router.SegueID.toMap.rawValue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let segueId = segue.identifier else { return }
        if segueId == Router.SegueID.toMap.rawValue, let selected = self.tableView.indexPathForSelectedRow {
            let mapController = segue.destination as! MapViewController
            mapController.device = self.devices[selected.row]
        }
    }
}

extension MainViewController {
    @objc func addPressed(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: Router.SegueID.toRegisterDevice.rawValue, sender: self)
    }
}
