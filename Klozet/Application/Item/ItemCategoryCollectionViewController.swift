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

    private lazy var myData = MyData()
    private lazy var myColor = MyColor()
    weak var cellSelectDelegate: CellSelectDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        collectionView.accessibilityIdentifier = AccessibilityId.itemCategoryCollectionView.description
        collectionView.backgroundColor = myColor.superLightGray
        
        registerCell()
        
        cellSelectDelegate = self
    }
    
    private func registerCell() {
        let nib = UINib(nibName: cellNibName, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        // TODO fix this lol
        let headerNib = UINib(nibName: "CategoryHeaderView", bundle: nil)
        collectionView.register(headerNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "CategoryHeader")
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
}

// MARK: - Data Source
extension ItemCategoryCollectionViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        if let categoryHeaderView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CategoryHeader", for: indexPath) as? CategoryHeaderView
        {
            if indexPath.section == 0 {
                categoryHeaderView.headerLabel.removeFromSuperview()
            } else {
                categoryHeaderView.headerLabel.text = "Accessories"
            }
            
            return categoryHeaderView
        }
        return UICollectionReusableView()
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? 3 : myData.itemCategories.count - 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CategoryCollectionViewCell
        let row = indexPath.section == 0 ? indexPath.row : indexPath.row + 3
        
        cell.nameLabel.text = myData.itemCategories[row].categoryName
        cell.descriptionLabel.text = myData.itemCategories[row].categoryDescription
        
        return cell
    }
}

// MARK: - Collection View Delegate
extension ItemCategoryCollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        cellSelectDelegate?.didSelect(atRow: indexPath.row)
    }
}

extension ItemCategoryCollectionViewController: CellSelectDelegate {
    func didSelect(atRow row: Int) {
        performSegue(withIdentifier: showItemCollectionSegueId, sender: row)
    }
}


extension ItemCategoryCollectionViewController: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
    {
        if section == 0 {
            return CGSize(width: 0, height: 0)
        } else {
            return CGSize(width: 30, height: 12)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = UIScreen.main.bounds.width - 24
        let itemHeight: CGFloat = 120
        return CGSize(width: itemWidth, height: itemHeight)
    }
}
