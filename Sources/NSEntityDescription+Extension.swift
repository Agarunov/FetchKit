//
//  NSEntityDescription+Extension.swift
//  FetchKit
//
//  Created by Anton Agarunov on 15.11.2017.
//
//

import CoreData
import Foundation

extension NSEntityDescription {

    open func attributeDescription(for name: String) -> NSAttributeDescription? {
        for (key, value) in attributesByName where key == name {
            return value
        }
        return nil
    }
    
}
