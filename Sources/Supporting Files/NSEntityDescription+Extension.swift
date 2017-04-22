//
//  NSEntityDescription+Extension.swift
//  FetchKit
//
//  Created by Anton Agarunov on 22.04.17.
//
//

import CoreData
import Foundation

internal extension NSEntityDescription {
    
    func attributeDescription(for name: String) -> NSAttributeDescription? {
        for (key, value) in attributesByName where key == name {
            return value
        }
        return nil
    }
    
}
