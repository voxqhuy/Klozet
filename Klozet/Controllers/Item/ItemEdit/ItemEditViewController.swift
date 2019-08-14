//
//  ItemEditViewController.swift
//  Klozet
//
//  Created by Developers on 8/13/19.
//

import UIKit
import Firebase

class ItemEditViewController: UIViewController {

    @IBOutlet var favoriteButton: UIButton!
    @IBOutlet var itemImageView: UIImageView!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var categoryTextField: UITextField!
    @IBOutlet var deleteItemButton: UIButton!
    
    var newItemImage: UIImage?
    
    private var itemCategories: [ItemCategory]?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setupNavigationItem()
    }
    
    private func setupNavigationItem() {
        navigationItem.title = "Item edit"
        
        navigationItem.leftBarButtonItem?.title = "Cancel"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        hideKeyboardWhenTappedAround()
        
        itemCategories = MyData().itemCategories
    }
    
    private func setupUI() {
        assignImageIfAddingItem()
        
        createCategoryPickerView()
        addChooseButton()
    }
    
    private func assignImageIfAddingItem() {
        if newItemImage != nil {
            itemImageView.image = newItemImage
        }
    }
    
    private func createCategoryPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        
        categoryTextField.inputView = pickerView
    }
    
    private func addChooseButton() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let chooseButton = UIBarButtonItem(title: "Choose", style: .plain, target: self, action: #selector(hideKeyboard))
        toolBar.setItems([chooseButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        categoryTextField.inputAccessoryView = toolBar
    }
    
//    @objc private func dismissKeyboard() {
//        view.endEditing(true)
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: - Interaction
    @objc private func saveButtonTapped() {
        if inputIsValid() {
            saveItem()
        }
    }
    
    private func saveItem() {
        let itemId = UUID.init().uuidString
        let selectedCategory = categoryTextField.text!
        let uploadRef = Storage.storage().reference(withPath: "voxqhuy/Items/\(selectedCategory)/\(itemId).jpg")
        
        guard let imageData = itemImageView.image?.jpegData(compressionQuality: 1.0) else { return }
        let uploadMetadata = StorageMetadata.init()
        uploadMetadata.contentType = "image/jpeg"
        
        uploadRef.putData(imageData, metadata: uploadMetadata) { (downloadMetadata, error) in
            if let error = error {
                print("voxError \(error.localizedDescription)")
            } else {
                print("Put is complete and I got this back: \(String(describing: downloadMetadata))")
            }
        }
    }
    
    
    // MARK: - Helpers
    private func inputIsValid() -> Bool {
        return true
        // TODO
    }
}

extension ItemEditViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return itemCategories!.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return itemCategories![row].categoryName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCategory = itemCategories![row].categoryName
        categoryTextField.text = selectedCategory
    }
}