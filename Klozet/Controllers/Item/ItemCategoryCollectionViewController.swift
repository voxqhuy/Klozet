//
//  ItemCategoryCollectionViewController.swift
//  Klozet
//
//  Created by Huy Vo on 8/3/19.
//

import UIKit

private let cellNibName = "CategoryCollectionViewCell"
private let reuseIdentifier = "CategoryCell"
private let showItemCollectionSegueId = "showItemCollection"

class ItemCategoryCollectionViewController: UICollectionViewController {

    private lazy var myString = MyString()
    private lazy var myColor = MyColor()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        collectionView.backgroundColor = myColor.superLightGray
        
        registerCell()
        

        // Do any additional setup after loading the view.
    }
    
    private func registerCell() {
        let nib = UINib(nibName: cellNibName, bundle: nil)
        collectionView!.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showItemCollectionSegueId {
            let itemCollectionVC = segue.destination as! ItemCollectionViewController
            
            guard let sender = sender as? Int else {
                return
            }
            itemCollectionVC.categoryIndex = sender
        }
    }
    
    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
}

// MARK: - Data Source
extension ItemCategoryCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CategoryCollectionViewCell
        
        cell.nameLabel.text = myString.itemCategoryName[indexPath.row]
        cell.descriptionLabel.text = myString.itemCategoryDescription[indexPath.row]
        
        return cell
    }
}

// MARK: - Collection View Delegate
extension ItemCategoryCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: showItemCollectionSegueId, sender: indexPath.row)
    }
}

extension ItemCategoryCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = UIScreen.main.bounds.width - 24
        let itemHeight: CGFloat = 120
        return CGSize(width: itemWidth, height: itemHeight)
    }
}



