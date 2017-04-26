//
//  NSManagedObject+Extension.swift
//  FetchKit
//
//  Created by Anton Agarunov on 22.04.17.
//
//

import CoreData
import Foundation

extension NSManagedObject {
    
    /// Returns entity name
    open class var fk_entityName: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }

}
