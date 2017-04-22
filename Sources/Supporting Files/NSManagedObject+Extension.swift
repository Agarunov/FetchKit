//
//  NSManagedObject+Extension.swift
//  FetchKit
//
//  Created by Anton Agarunov on 22.04.17.
//
//

import CoreData
import Foundation

public extension NSManagedObject {
    
    public class var fk_entityName: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }

}
