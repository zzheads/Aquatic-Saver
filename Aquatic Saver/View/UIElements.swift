//
//  UIElements.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 28.08.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import Foundation
import Material

struct UIElements {
    struct AppColor {
        static let darkBlue = UIColor(red: 33/255, green: 80/255, blue: 113/255, alpha: 1.0)
    }
    
    struct Font {
        static func regular(_ size: CGFloat) -> UIFont? {
            return UIFont(name: "RobotoCondensed-Regular", size: size)
        }
        static func light(_ size: CGFloat) -> UIFont? {
            return UIFont(name: "RobotoCondensed-Light", size: size)
        }
        static func bold(_ size: CGFloat) -> UIFont? {
            return UIFont(name: "RobotoCondensed-Bold", size: size)
        }
    }
    
    class ViewController: UIViewController {
        override func viewDidLoad() {
            super.viewDidLoad()
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.backPressed(_:)))
            if let font = UIElements.Font.bold(12.0) {
                let attributes = [NSAttributedStringKey.font: font]
                self.navigationItem.leftBarButtonItem?.setTitleTextAttributes(attributes, for: .normal)
                self.navigationItem.leftBarButtonItem?.setTitleTextAttributes(attributes, for: .highlighted)
            }
        }
        
        @objc func backPressed(_ sender: UIBarButtonItem) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    static func textField(_ placeholder: String? = nil, color: UIColor = AppColor.darkBlue, font: UIFont? = Font.regular(12.0), isPass: Bool = false) -> TextField {
        let textField = TextField()
        textField.font = font
        textField.placeholder = placeholder
        textField.textColor = color
        textField.dividerActiveColor = AppColor.darkBlue
        textField.placeholderActiveColor = AppColor.darkBlue
        textField.autocapitalizationType = .none
        if isPass {
            textField.isSecureTextEntry = true
            textField.isVisibilityIconButtonEnabled = true
            textField.isVisibilityIconButtonAutoHandled = true
        }
        textField.sizeToFit()
        return textField
    }
    
    static func raisedButton(_ title: String? = nil, titleColor: UIColor = .white, backColor: UIColor = AppColor.darkBlue, font: UIFont? = Font.bold(14.0)) -> RaisedButton {
        let button = RaisedButton(title: title, titleColor: titleColor)
        button.titleLabel?.font = font
        button.backgroundColor = backColor
        return button
    }
    
    static func flatButton(_ title: String? = nil, titleColor: UIColor = AppColor.darkBlue, backColor: UIColor = .clear, font: UIFont? = Font.regular(12.0)) -> FlatButton {
        let button = FlatButton(title: title, titleColor: titleColor)
        button.titleLabel?.font = font
        button.backgroundColor = backColor
        return button
    }
    
    static func checkButton(_ title: String?, titleColor: UIColor = AppColor.darkBlue) -> CheckButton {
        let button = CheckButton(title: title, titleColor: titleColor)
        button.titleLabel?.font = Font.regular(12.0)
        button.checkmarkColor = .white
        button.setIconColor(AppColor.darkBlue, for: .selected)
        button.iconSize = 12
        return button
    }
}
