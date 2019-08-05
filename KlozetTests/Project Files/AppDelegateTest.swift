//
//  AppDelegateTest.swift
//  KlozetTests
//
//  Created by Huy Vo on 8/4/19.
//

import XCTest
@testable import Klozet

class AppDelegateTest: XCTestCase {
    
    var sut: AppDelegate!
    var app: UIApplication!
    override func setUp() {
        super.setUp()
        sut = AppDelegate()
        app = UIApplication.shared
    }
    
    override func tearDown() {
        sut = nil
        app = nil
        super.tearDown()
    }
    
    func testAppDelegate() {
        sut.applicationWillResignActive(app)
        sut.applicationDidEnterBackground(app)
        sut.applicationWillEnterForeground(app)
        sut.applicationDidBecomeActive(app)
        sut.applicationWillTerminate(app)
    }
    
}
