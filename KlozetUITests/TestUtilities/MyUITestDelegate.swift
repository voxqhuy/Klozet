//
//  MyUITestDelegate.swift
//  KlozetUITests
//
//  Created by Huy Vo on 8/4/19.
//

import XCTest

protocol UITestable {
    var app: XCUIApplication! { get set }
    // Switch taps
    func goToFirstTab()
    func goToSecondTab()
    func goToThirdTab()
    
    // Switch view controllers
    func goToLabCollectionViewController()
    
    // Interactions
    func tapOutside(inVC viewController: MyViewController)
//    func swipeView(inVC viewController: MyViewController, toView destinationView: XCUIElement?)
//    func getSearchBar(inVC viewController: MyViewController) -> XCUIElement?
    func getFirstCell(inVC viewController: MyViewController) -> XCUIElement?
//    func proceedAlertButton(ofCase alertCase: AlertCase)
}

extension UITestable where Self: XCTestCase {
    // MARK: - Switch Tabs
    func goToFirstTab() {
        let tabBarButtons = XCUIApplication().tabBars.buttons
        tabBarButtons.element(boundBy: 0).tap()
    }
    
    func goToSecondTab() {
        let tabBarButtons = XCUIApplication().tabBars.buttons
        tabBarButtons.element(boundBy: 1).tap()
    }
    
    func goToThirdTab() {
        let tabBarButtons = XCUIApplication().tabBars.buttons
        tabBarButtons.element(boundBy: 2).tap()
    }
    
    // MARK: - Switch View Controllers
    func goToLabCollectionViewController() {
        return
    }
    
    // MARK: - Interactions
    func tapOutside(inVC viewController: MyViewController) {
        let mainView: XCUIElement
        switch viewController {
        case .itemCategoryCollectionViewController:
            mainView = app.otherElements[AccessibilityId.itemCategoryCollectionView.description]
        default:
            return
        }
        
        let coordinate = mainView.coordinate(withNormalizedOffset: CGVector.zero).withOffset(CGVector(dx: 10,dy: 1))
        coordinate.tap()
    }
    
//    func swipeView(inVC viewController: MyViewController, toView destinationView: XCUIElement? = nil) {
//        let view: XCUIElement
//        switch viewController {
//        case .labCollection:
//            view = app.collectionViews[AccessibilityId.labCollectionView.description]
//        default:
//            return
//        }
//        //        let searchBar = getSearchBar(inVC: viewController)!
//        if let destinationView = destinationView {
//            view.cells.element(boundBy: 0).press(forDuration: 1, thenDragTo: destinationView)
//        } else {
//            view.swipeUp()
//        }
//    }
    
//    func getSearchBar(inVC viewController: MyViewController) -> XCUIElement? {
//        let searchBar: XCUIElement?
//        switch viewController {
//        case .labCollection:
//            searchBar = app.otherElements[AccessibilityId.labCollectionSearchBar.description]
//        default:
//            return nil
//        }
//        return searchBar
//    }
    
    func getFirstCell(inVC viewController: MyViewController) -> XCUIElement? {
        switch viewController {
        case .itemCategoryCollectionViewController:
            return app.collectionViews[AccessibilityId.itemCategoryCollectionView.description].cells.element(boundBy: 0)
        default:
            return nil
        }
    }
    
//    func proceedAlertButton(ofCase alertCase: AlertCase) {
//        let buttonText: String
//
//        switch alertCase {
//        case .invalidLabInfoInput:
//            buttonText = AlertString.okay
//        }
//
//        let alertButton = app.buttons[buttonText]
//        alertButton.tap()
//    }
}

typealias MyUITestDelegate = XCTestCase & UITestable
