//
//  ItemEditViewController.swift
//  Klozet
//
//  Created by Developers on 8/13/19.
//

import UIKit
import CoreData

class ItemEditViewController: UIViewController {
    internal var newItemImage: UIImage?
    
    private var itemView: ItemInfoView!
    private var favoriteButton: UIButton!
    private var itemImageView: UIImageView!
    private var nameTextField: UITextField!
    private var categoryTextField: UITextField!
    private var deleteItemButton: UIButton!
    
    private var itemCategories: [ItemCategory]?
    private lazy var service = FirestoreService()
    private var imagePath: String!
    
    private var managedContext: NSManagedObjectContext!
    private let coreDataEntity = "Item"
    
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
        if inputIsInvalid {
            presentAlert(forCase: .invalidItemInput)
        } else {
            saveItemToCoreData()
            saveItemToFirebase()
        }
    }
    
    private func saveItem() {
        let selectedCategory = categoryTextField.text!
        
        
        
        service.uploadImageAndGetPath(for: itemImageView.image!, withCategory: selectedCategory) {
            [weak self] (uploadResult) in
            guard let self = self else { return }
            
            switch uploadResult {
            case let .failure(errorString):
                print(errorString)
                self.presentAlert(forCase: .failToUploadItemImage)
                
            case let .success(imagePath):
                self.imagePath = imagePath
                self.saveItemToCoreData(with: imagePath)
            }
        }
    }
    
    
    // MARK: - Helpers
    private var inputIsInvalid: Bool {
        return nameTextField.text?.isEmpty ?? true ||
            categoryTextField.text?.isEmpty ?? true
    }
    
    private func saveItemToCoreData() {
        let myCoreData = MyCoreData(modelName: "Klozet")
        managedContext = myCoreData.managedContext
        
        assignPropertiesToItem()
        
        myCoreData.saveContext()
        //try! managedContext.save()
    }
    
    private func assignPropertiesToItem() {
        let item = NSEntityDescription.insertNewObject(forEntityName: coreDataEntity, into: managedContext) as! Item
        item.itemName = nameTextField.text
        item.category = categoryTextField.text
        item.isFavorite = false // TODO make favorite button
        item.imagePath = imagePath
    }
    
    private func saveItemToFirebase() {
        // TODO
        // save
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
