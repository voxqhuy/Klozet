//
//  ItemEditViewController.swift
//  Klozet
//
//  Created by Developers on 8/13/19.
//

import UIKit
import CoreData

class ItemEditViewController: UIViewController {
    // MARK: Variables
    internal var newItemImage: UIImage?
    
    private var itemView: ItemInfoView!
    private var favoriteButton: UIButton!
    private var itemImageView: UIImageView!
    private var nameTextField: UITextField!
    private var categoryTextField: UITextField!
    private var deleteItemButton: UIButton!
    
    private var itemCategories: [ItemCategory]?
    private var worker: ItemEditWorker!
    private var imagePath: String!
    
    
    // MARK: - View cycles
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
        
        setupMainView()
        setupUI()
        hideKeyboardWhenTappedAround()
        
        itemCategories = MyData().itemCategories
    }
    
    private func setupMainView() {
        addMainView()
        assignViews()
    }
    
    private func addMainView() {
        itemView = Bundle.main.loadNibNamed("ItemInfoView", owner: self, options: nil)!.first as? ItemInfoView
        //            itemView.removeFromSuperview()
        view.addSubview(itemView)
        itemView.frame = view.bounds
        itemView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    private func assignViews() {
        favoriteButton = itemView.favoriteButton
        itemImageView = itemView.itemImageView
        nameTextField = itemView.itemNameTextField
        categoryTextField = itemView.itemCategoryTextField
        deleteItemButton = itemView.deleteItemButton
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


    // MARK: - Interaction
    @objc private func saveButtonTapped() {
        if inputIsInvalid {
            presentAlert(forCase: .invalidItemInput)
        } else {
            saveItem()
            // TODO then go back
            
        }
    }
    
    private func saveItem() {
        let itemModel =
            ItemModel(name: nameTextField.text!,
                      category: categoryTextField.text!,
                      isFavorite: false,
                      image: itemImageView.image!)
        
        worker = ItemEditWorker(itemModel: itemModel)
        worker.saveItemToCoreData { (saveCoreDataResult) in
            switch saveCoreDataResult {
            case let .failure(errorString):
                // TODO make a case
                print(errorString)
                presentAlert(forCase: .failToUploadItemImage)
                return
            case .success: break
            }
        }
        
        worker.saveItemToFirebase()
        
    }
}


// MARK: - Picker View
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


// MARK: - Helpers
extension ItemEditViewController {
    private var inputIsInvalid: Bool {
        return nameTextField.text?.isEmpty ?? true ||
            categoryTextField.text?.isEmpty ?? true
    }
    
    private func saveItemToFirebase() {
        // TODO
        // save
    }
}
