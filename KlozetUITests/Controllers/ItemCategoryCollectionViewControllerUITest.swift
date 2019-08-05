//
//  ItemCategoryCollectionViewControllerUITest.swift
//  KlozetUITests
//
//  Created by Huy Vo on 8/4/19.
//

import XCTest
@testable import Klozet

class ItemCategoryCollectionViewControllerUITest: MyUITestDelegate {

    var app: XCUIApplication!
    var thisViewController: MyViewController!
    override func setUp() {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launch()
        thisViewController = .itemCategoryCollectionViewController
        goToThirdTab()
    }
    
    override func tearDown() {
        app = nil
        thisViewController = nil
        super.tearDown()
    }
    

    func testCellSelect() {
        // GIVEN
        let firstCell = getFirstCell(inVC: thisViewController)
        XCTAssertTrue(firstCell!.isHittable)
        
        // WHEN
        firstCell?.tap()
        
        // THEN
        // TODO check an item in ItemCollectionVC exists
    }

}
