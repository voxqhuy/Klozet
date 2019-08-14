//
//  ItemCollectionViewController.swift
//  Klozet
//
//  Created by Huy Vo on 8/3/19.
//

import UIKit

private let cellNibName = "GridCollectionViewCell"
private let reuseIdentifier = "GridCell"
private let showItemEditSegueId = "showItemEdit"

class ItemCollectionViewController: UICollectionViewController {

    var categoryIndex: Int?
    
    private var myData = MyData()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = myData.itemCategories[categoryIndex!].categoryName
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add item", style: .plain, target: self, action: #selector(addItemButtonTapped(_:)))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    
    // MARK: Interaction
    @objc private func addItemButtonTapped(_ sender: UIBarButtonItem) {
        promptUserToAddItem(on: sender)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        setupBackButton()
        
        if segue.identifier == showItemEditSegueId {
            let itemEditVC = segue.destination as! ItemEditViewController
            itemEditVC.newItemImage = sender as? UIImage
        }
    }
    
    private func setupBackButton() {
        let backItem = UIBarButtonItem()
        backItem.title = "Cancel"
        navigationItem.backBarButtonItem = backItem
    }
    

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

}

extension ItemCollectionViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else { return }
        print("image selected \(image)")
        // TODO perform segue to show Item Edit
        performSegue(withIdentifier: showItemEditSegueId, sender: image)
    }
}
