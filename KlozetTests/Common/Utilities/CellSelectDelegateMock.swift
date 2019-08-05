//
//  CellSelectDelegateMock.swift
//  KlozetTests
//
//  Created by Huy Vo on 8/4/19.
//

import Foundation
@testable import Klozet

class CellSelectDelegateMock: CellSelectDelegate {
    var didSelectCell = false
    var row: Int?
    
    func didSelect(atRow row: Int) {
        didSelectCell = true
        self.row = row
    }
}
