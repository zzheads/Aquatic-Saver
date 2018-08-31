//
//  MainViewController.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 31.08.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import UIKit

class MainViewController: UIElements.ViewController {


    override func viewDidLoad() {
        super.viewDidLoad()
        print("Web service logged: \(WebService.default.isLogged)")
        APIClient.default.allDevices().done{ print("All devices: \($0)") }.catch{ print($0) }
    }
}
