//
//  UIViewController +.swift
//  Aquatic Saver
//
//  Created by Алексей Папин on 04.09.2018.
//  Copyright © 2018 Алексей Папин. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, style: UIAlertControllerStyle, completion: (() -> Void)? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            guard let completion = completion else {
                return
            }
            completion()
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertAndAsk(title: String, message: String, style: UIAlertControllerStyle, completion: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            completion(true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            completion(false)
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertAndPrompt(title: String, message: String, style: UIAlertControllerStyle, defaultValue: String?, completion: @escaping (String?) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        alertController.addTextField()
        alertController.textFields?.first?.text = defaultValue
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            guard let textField = alertController.textFields?.first else {
                return
            }
            completion(textField.text)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            completion(nil)
        }
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func toast(_ message: String) {
        let width = UIScreen.main.bounds.size.width * 0.75
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - width/2, y: self.view.frame.size.height - 100, width: width, height: 35))
        toastLabel.numberOfLines = 0
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIElements.Font.regular(13.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

