//
//  MyAlert.swift
//  Klozet
//
//  Created by Developers on 8/22/19.
//

import Foundation

enum MyAlert {
    case error(MyError)
    
    case validation(ValidationStatus)
    
    var description: String {
        return String(describing: self)
    }
}
