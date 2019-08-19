//
//  ItemCollectionViewController.swift
//  Klozet
//
//  Created by Huy Vo on 8/3/19.
//

import UIKit
import CoreData

private let cellNibName = "GridCollectionViewCell"
private let reuseIdentifier = "GridCell"
private let showItemEditSegueId = "showItemEdit"

class ItemCollectionViewController: UICollectionViewController {

    internal var categoryName: String?
    
    private lazy var myCoreData = MyCoreData(modelName: "Klozet")
    private var fetchedResultsController: NSFetchedResultsController<Item>!
    
    private var items = [Item]()
    
    
    // MARK: View cycles
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationItem.title = categoryName
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add item", style: .plain, target: self, action: #selector(addItemButtonTapped(_:)))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        fetchItems()
    }
    
    private func fetchItems() {
        addFetchRequestToFetchedResultsController()
        performFetch()
    }
    
    private func addFetchRequestToFetchedResultsController() {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: myCoreData.managedContext,
            sectionNameKeyPath: nil,
            cacheName: nil)
    }
    
    private func performFetch() {
        do {
            try fetchedResultsController.performFetch()
        } catch let error as NSError {
            print("Fetching error: \(error), \(error.userInfo)")
        }
    }
    
    
    // MARK: Interaction
    @objc private func addItemButtonTapped(_ sender: UIBarButtonItem) {
        promptUserToAddItem(on: sender)
    }

    
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        setupBackButton()
        
        if segue.identifier == showItemEditSegueId {
            let itemEditVC = segue.destination as! ItemEditViewController
            itemEditVC.newItemImage = sender as? UIImage
        }
    }
    
    private func setupBackButton()
    {
        let backItem = UIBarButtonItem()
        backItem.title = "Cancel"
        navigationItem.backBarButtonItem = backItem
    }
}


// MARK: - Collection View
extension ItemCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        guard let itemSectionInfo = fetchedResultsController.sections?[section] else {
            return 0
        }
        
        return itemSectionInfo.numberOfObjects
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GridCollectionViewCell
        
        let item = fetchedResultsController.object(at: indexPath)
        //        cell.itemImageView = item. TODO
        
        return cell
    }
}


//MARK: - Image Picker Delegate
extension ItemCollectionViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.editedImage] as? UIImage else { return }
        print("image selected \(image)")
        // TODO perform segue to show Item Edit
        performSegue(withIdentifier: showItemEditSegueId, sender: image)
    }
}
