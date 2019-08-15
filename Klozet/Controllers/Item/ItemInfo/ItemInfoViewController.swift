//
//  ItemInfoViewController.swift
//  Klozet
//
//  Created by Developers on 8/13/19.
//

import UIKit

class ItemInfoViewController: UIViewController {
    internal var selectedItemName: String?
    
    private var itemView: ItemInfoView!
    private var favoriteButton: UIButton!
    private var itemImageView: UIImageView!
    private var nameTextField: UITextField!
    private var categoryTextField: UITextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupMainView()
    }
    
    private func setupMainView() {
        addMainView()
        loadViews()
    }
    
    private func addMainView() {
        itemView = Bundle.main.loadNibNamed("ItemInfoView", owner: self, options: nil)!.first as? ItemInfoView
        //            itemView.removeFromSuperview()
        view.addSubview(itemView)
        itemView.frame = view.bounds
        itemView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    private func loadViews() {
        favoriteButton = itemView.favoriteButton
        itemImageView = itemView.itemImageView
        nameTextField = itemView.itemNameTextField
        categoryTextField = itemView.itemCategoryTextField
        itemView.deleteItemButton.removeFromSuperview()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
}
