//
//  ItemCategoryViewControllerTest.swift
//  KlozetTests
//
//  Created by Huy Vo on 8/4/19.
//

import XCTest
@testable import Klozet

//class ItemCategoryDataSource: NSObject, UICollectionViewDataSource {
//    private let reuseIdentifier = "CategoryCell"
//    lazy var myDataMock = MyDataMock()
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return myDataMock.itemCategoryName.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CategoryCollectionViewCell
//
//        cell.nameLabel.text = myDataMock.itemCategoryName[indexPath.row]
//        cell.descriptionLabel.text = myDataMock.itemCategoryDescription[indexPath.row]
//
//        return cell
//    }
//
//
//}

class ItemCategoryViewControllerTest: XCTestCase {

    var sut: ItemCategoryCollectionViewController!
    var destinationSut: ItemCollectionViewController!
    lazy var myColor = MyColor()
    lazy var myData = MyData()
//    lazy var myDataSource = ItemCategoryDataSource()
    private let cellSelectDelegateMock = CellSelectDelegateMock()
    private let showItemCollectionSegueId = "showItemCollection"
    
    override func setUp() {
        
        sut = MyController.itemCategoryCollectionViewController.instance as? ItemCategoryCollectionViewController
        destinationSut = MyController.itemCollectionViewController.instance as? ItemCollectionViewController
        
        let _ = sut.view
        sut.cellSelectDelegate = cellSelectDelegateMock
//        sut.collectionView.dataSource = myDataSource
    }

    override func tearDown() {
        sut = nil
        destinationSut = nil
    }

    func testViewDidLoad() {
        XCTAssertEqual(sut.collectionView!.backgroundColor, myColor.superLightGray)
    }
    
    func testPrepareSegueWithSender() {
        // GIVEN
        let showItemCollectionSegue = UIStoryboardSegue(identifier: showItemCollectionSegueId, source: sut, destination: destinationSut)
        
        // WHEN
        sut.prepare(for: showItemCollectionSegue, sender: 1)
        
        // THEN
        XCTAssertEqual(destinationSut.categoryIndex!, 1)
    }
    
    func testPrepareSegueWithoutSender() {
        // GIVEN
        let showItemCollectionSegue = UIStoryboardSegue(identifier: showItemCollectionSegueId, source: sut, destination: destinationSut)
        
        // WHEN
        sut.prepare(for: showItemCollectionSegue, sender: nil)
        
        // THEN
        XCTAssertNil(destinationSut.categoryIndex)
    }


    
    func testUICollectionViewDataSource() {
        XCTAssertEqual(sut.collectionView(sut.collectionView!, numberOfItemsInSection: 0), 4)
        
        let cell = sut.collectionView(sut.collectionView, cellForItemAt: IndexPath(row: 0, section: 0)) as! CategoryCollectionViewCell
        
        cell.nameLabel.text = myData.itemCategoryName[0]
        cell.descriptionLabel.text = myData.itemCategoryDescription[0]
//        cell.nameLabel.text = myString.itemCategoryName[indexPath.row]
//        cell.descriptionLabel.text = myString.itemCategoryDescription[indexPath.row]
    }
    
    func testDidSelectItemAt() {
        sut.collectionView(sut.collectionView, didSelectItemAt: IndexPath(row: 0, section: 0))
        
        // THEN
        XCTAssertTrue(cellSelectDelegateMock.didSelectCell)
        XCTAssertEqual(cellSelectDelegateMock.row, 0)
    }
    
    func testUICollectionViewDelegateFlowLayout() {
        XCTAssertEqual(sut.collectionView(sut.collectionView!, layout: sut.collectionView.collectionViewLayout, insetForSectionAt: 0), UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12))
        
        XCTAssertTrue(sut.responds(to: #selector(sut.collectionView(_:layout:sizeForItemAt:))))
    }
}
