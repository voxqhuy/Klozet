//
//  ItemEditViewController.swift
//  Klozet
//
//  Created by Developers on 8/13/19.
//

import UIKit
import CoreData

struct NewItem {
    let categoryIndex: Int
    let image: UIImage
}

class ItemEditViewController: UIViewController {
    // MARK: Variables
    internal var newItemData: NewItem? = nil
    internal var editingItemId: UUID? = nil
    
    private var itemView: ItemInfoView!
    private var favoriteButton: UIButton!
    private var itemImageView: UIImageView!
    private var nameTextField: UITextField!
    private var categoryTextField: UITextField!
    private var deleteItemButton: UIButton!
    
    private var itemCategories: [ItemCategory] = MyData().itemCategories
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
        
//        itemCategories = MyData().itemCategories
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
        assignDataIfAddingItem()
        
        createCategoryPickerView()
        addChooseButton()
    }
    
    private func assignDataIfAddingItem() {
        if let data = newItemData {
            itemImageView.image = data.image
            categoryTextField.text = itemCategories[data.categoryIndex].categoryName
        }
    }
    
    private func createCategoryPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        
        if let selectedCategoryIndex = newItemData?.categoryIndex {
            pickerView.selectRow(selectedCategoryIndex, inComponent: 0, animated: true)
        }
        
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
            presentAlert(for: .validation(.invalidItemInput), handler: nil)
        } else {
            initializeWorker()
            saveItemAndGoBack()
        }
    }
    
    private func initializeWorker() {
        let itemModel =
            ItemModel(name: nameTextField.text!,
                      category: categoryTextField.text!,
                      isFavorite: false,
                      image: itemImageView.image!)
        
        worker = ItemEditWorker(itemModel: itemModel)
    }
    
    private func saveItemAndGoBack() {
        if editingItemId == nil {
            createNewItemAndGoBack()
        } else {
            updateItemEditAndGoBack()
        }
    }
    
    private func createNewItemAndGoBack()
    {
        worker?.createItem { [weak self] (createResult) in
            guard let self = self else { return }
            
            switch createResult {
            case let .failure(error):
                self.presentAlert(for: .error(error), handler: nil)
                
            case .success:
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func updateItemEditAndGoBack()
    {
        worker.updateItem { [weak self] (updateResult) in
            guard let self = self else { return }
            
            switch updateResult {
            case let .failure(error):
                self.presentAlert(for: .error(error), handler: nil)
                
            case .success:
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}


// MARK: - Picker View
extension ItemEditViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return itemCategories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return itemCategories[row].categoryName
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCategory = itemCategories[row].categoryName
        categoryTextField.text = selectedCategory
    }
}


// MARK: - Helpers
extension ItemEditViewController {
    private var inputIsInvalid: Bool {
        return nameTextField.text?.isEmpty ?? true ||
            categoryTextField.text?.isEmpty ?? true
    }
}
