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
    struct Color {
        static let darkBlue = UIColor(red: 33/255, green: 80/255, blue: 113/255, alpha: 1.0)
        static let lightBlue = UIColor(red: 224/255, green: 239/255, blue: 251/255, alpha: 1.0)
        static let darkRed = UIColor(red: 188/255, green: 31/255, blue: 86/255, alpha: 1.0)
    }
    
    struct Font {
        static let fontFamilyName = "Rubik"
        
        enum FontStyle: String {
            case regular
            case medium
            case light
            case bold
            
            var styleName: String {
                return self.rawValue.capitalized
            }
            
            var fontName: String {
                return "\(fontFamilyName)-\(self.styleName)"
            }
        }
        static func font(style: FontStyle, size: CGFloat) -> UIFont? {
            guard let font = UIFont(name: style.fontName, size: size) else {
                print("Font \(style.fontName) not found.")
                return nil
            }
            return font
        }
        
        static func regular(_ size: CGFloat) -> UIFont? {
            return font(style: .regular, size: size)
        }
        static func light(_ size: CGFloat) -> UIFont? {
            return font(style: .light, size: size)
        }
        static func bold(_ size: CGFloat) -> UIFont? {
            return font(style: .bold, size: size)
        }
        static func medium(_ size: CGFloat) -> UIFont? {
            return font(style: .medium, size: size)
        }
    }
    
    static let settingsImage = UIImage(named: "Settings2")
    
    class ViewController: UIViewController {
        override func viewDidLoad() {
            super.viewDidLoad()
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.backPressed(_:)))
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIElements.settingsImage?.crop(toWidth: 20, toHeight: 20), style: .plain, target: self, action: #selector(self.settingsPressed(_:)))
            ViewController.setAttributes(for: [self.navigationItem.leftBarButtonItem, self.navigationItem.rightBarButtonItem])
            self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIElements.Font.medium(15.0) as Any]
            self.navigationItem.title = "Aquatic Saver"
        }
        
        class func setAttributes(for buttons: [UIBarButtonItem?]) {
            guard let font = UIElements.Font.medium(12.0) else {
                print("Font not found")
                return
            }
            let attributes = [NSAttributedStringKey.font: font]
            buttons.forEach {
                $0?.setTitleTextAttributes(attributes, for: .normal)
                $0?.setTitleTextAttributes(attributes, for: .highlighted)
            }
        }
        
        @objc func backPressed(_ sender: UIBarButtonItem) {
            self.navigationController?.popViewController(animated: true)
        }
        
        @objc func settingsPressed(_ sender: UIBarButtonItem) {
            self.navigationController?.performSegue(withIdentifier: Router.SegueID.toSettings.rawValue, sender: self)
        }
    }
    
    static func textField(_ placeholder: String? = nil, color: UIColor = Color.darkBlue, font: UIFont? = Font.regular(12.0), isPass: Bool = false) -> TextField {
        let textField = TextField()
        textField.font = font
        textField.placeholder = placeholder
        textField.textColor = color
        textField.dividerActiveColor = Color.darkBlue
        textField.placeholderActiveColor = Color.darkBlue
        textField.autocapitalizationType = .none
        if isPass {
            textField.isSecureTextEntry = true
            textField.isVisibilityIconButtonEnabled = true
            textField.isVisibilityIconButtonAutoHandled = true
        }
        textField.sizeToFit()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }
    
    static func raisedButton(_ title: String? = nil, titleColor: UIColor = .white, backColor: UIColor = Color.darkBlue, font: UIFont? = Font.medium(14.0)) -> RaisedButton {
        let button = RaisedButton(title: title, titleColor: titleColor)
        button.titleLabel?.font = font
        button.backgroundColor = backColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    static func flatButton(_ title: String? = nil, titleColor: UIColor = Color.darkBlue, backColor: UIColor = .clear, font: UIFont? = Font.regular(12.0)) -> FlatButton {
        let button = FlatButton(title: title, titleColor: titleColor)
        button.titleLabel?.font = font
        button.backgroundColor = backColor
        return button
    }
    
    static func checkButton(_ title: String?, titleColor: UIColor = Color.darkBlue) -> CheckButton {
        let button = CheckButton(title: title, titleColor: titleColor)
        button.titleLabel?.font = Font.regular(12.0)
        button.checkmarkColor = .white
        button.setIconColor(Color.darkBlue, for: .selected)
        button.iconSize = 12
        return button
    }
}
