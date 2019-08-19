//
//  UIViewController+presentAlert.swift
//  Klozet
//
//  Created by Developers on 8/15/19.
//

import UIKit

enum AlertCase {
    case invalidItemInput
    
    case failToUploadItemImage
    
    var description: String {
        return String(describing: self)
    }
}

extension UIAlertController {
    func addActions(forCase alertCase: AlertCase, handler: ((UIAlertAction) -> Void)?) {
        switch alertCase {
        case .invalidItemInput,
             .failToUploadItemImage:
            addAction(UIAlertAction(title: "Okay", style: .default, handler: handler))
        }
    }
}

extension UIViewController {
    func presentAlert(forCase alertCase: AlertCase, handler: ((UIAlertAction) -> Void)? = nil) {
        
        let ac = alertController(forCase: alertCase)
        ac.addActions(forCase: alertCase, handler: handler)
        
        ac.view.accessibilityIdentifier = alertCase.description
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            ac.popoverPresentationController?.sourceView = self.view
            ac.popoverPresentationController?.sourceRect = self.view.bounds
            ac.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        
        present(ac, animated: true, completion: nil)
    }
    
    private func alertController(forCase alertCase: AlertCase) -> UIAlertController {
        let ac: UIAlertController
        
        switch alertCase {
        case .invalidItemInput:
            ac = UIAlertController(title: "Oops!", message: "Please make sure the item has a name and a category", preferredStyle: .alert)
        case .failToUploadItemImage:
            ac = UIAlertController(title: "Cannot save this image", message: "Fail to save this item image. Please try again later", preferredStyle: .alert)
        }
        
        return ac
    }
}
