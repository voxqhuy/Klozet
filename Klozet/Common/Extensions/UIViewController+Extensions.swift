//
//  UIViewController+Extensions.swift
//  Klozet
//
//  Created by Developers on 8/14/19.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGestureRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
}
