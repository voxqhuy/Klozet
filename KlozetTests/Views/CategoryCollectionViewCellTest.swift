//
//  CategoryCollectionViewCellTest.swift
//  KlozetTests
//
//  Created by Huy Vo on 8/4/19.
//

import XCTest
@testable import Klozet

class CategoryCollectionViewCellTest: XCTestCase {

    var sut: CategoryCollectionViewCell!
    private let cellNibName = "CategoryCollectionViewCell"
    override func setUp() {
        super.setUp()
        
        let bundle = Bundle(for: CategoryCollectionViewCell.self)
        let nib = bundle.loadNibNamed(cellNibName, owner: nil, options: nil)
        sut = nib?.first as? CategoryCollectionViewCell
    }

    override func tearDown() {
        sut = nil
        
        super.tearDown()
    }

    func testAwakeFromNib() {
        XCTAssertEqual(sut.backgroundColor, .clear)
        XCTAssertFalse(sut.layer.masksToBounds)
        XCTAssertEqual(sut.layer.shadowOpacity, 0.14)
        XCTAssertEqual(sut.layer.shadowRadius, 4)
        XCTAssertEqual(sut.layer.shadowOffset, CGSize(width: 0, height: 0))
        XCTAssertEqual(sut.layer.shadowColor, UIColor.black.cgColor)
        XCTAssertEqual(sut.contentView.backgroundColor, .white)
        XCTAssertEqual(sut.contentView.layer.cornerRadius, 8)
    }

}
