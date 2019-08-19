//
//  ItemCollectionViewController+addItem.swift
//  Klozet
//
//  Created by Developers on 8/12/19.
//

import UIKit

extension ItemCollectionViewController {
    func promptUserToAddItem(on sourceView: UIBarButtonItem) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        addActions(to: alertController)
//        checkIfOnIpadDevice(for: alertController, from: sourceView)
        
        alertController.view.accessibilityIdentifier = AccessibilityId.addItemActionSheet.description
        
        present(alertController, animated: true)
    }
    
    private func addActions(to alertController: UIAlertController) {
        if let action = makeAction(for: .camera, title: "Take photo") {
            alertController.addAction(action)
        }
        if let action = makeAction(for: .savedPhotosAlbum, title: "Camera roll") {
            alertController.addAction(action)
        }
        if let action = makeAction(for: .photoLibrary, title: "Photo library") {
            alertController.addAction(action)
        }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    }
    
    private func makeAction(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        
        return UIAlertAction(title: title, style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            imagePickerController.sourceType = type
            self.present(imagePickerController, animated: true)
        })
    }
    
//    private func checkIfOnIpadDevice(for alertController: UIAlertController, from sourceView: UIBarButtonItem) {
//        // set the proper source view & rect, otherwise the app will crash on iPads
//        if UIDevice.current.userInterfaceIdiom == .pad {
//            alertController.popoverPresentationController?.sourceView = sourceView
//            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
//            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
//        }
//    }
}

