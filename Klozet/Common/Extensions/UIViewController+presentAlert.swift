//
//  UIViewController+presentAlert.swift
//  Klozet
//
//  Created by Huy Vo on 8/15/19.
//

import UIKit


extension UIViewController {
    func presentAlert(for alertCase: MyAlert, handler: ((UIAlertAction) -> Void)?) {
        print(alertCase.description)
        
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
    
    private func alertController(forCase alertCase: MyAlert) -> UIAlertController {
        let ac: UIAlertController
        
        switch alertCase
        {
        case let .validation(status):
            switch status
            {
            case .invalidItemInput:
                ac = UIAlertController(title: "Oops!", message: "Please make sure the item has a name and a category", preferredStyle: .alert)
            }
            
        case let .error(error):
            switch error
            {
            case .failToCacheImage:
                ac = UIAlertController(title: "Cannot save this image", message: "Fail to save this item image. Please try again later", preferredStyle: .alert)
                
            case .failToFetchItemFromCoreData:
                ac = UIAlertController(title: "Cannot load this item", message: "Fail to load this item. Please try again later", preferredStyle: .alert)
                
            case.failToCreateItemOnFirebase,
                .failToUploadImageOnFirebase:
                ac = UIAlertController(title: "Cannot create this item", message: "Fail to create this item. Please check your internet connection and try again later", preferredStyle: .alert)
                
            case .failToUpdateItemOnFirebase:
                ac = UIAlertController(title: "Cannot save edits this item", message: "Fail to save edits for this item. Please check your internet connection and try again later", preferredStyle: .alert)
            }
        }
        return ac
    }
}

extension UIAlertController {
    func addActions(forCase alertCase: MyAlert, handler: ((UIAlertAction) -> Void)?)
    {
        switch alertCase
        {
        case let .validation(status):
            switch status
            {
            case .invalidItemInput:
                addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                
            }
            
        case let .error(error):
            switch error
            {
            case .failToCacheImage,
                 .failToFetchItemFromCoreData,
                 .failToCreateItemOnFirebase,
                 .failToUpdateItemOnFirebase,
                 .failToUploadImageOnFirebase:
                addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            }
        }
    }
}
