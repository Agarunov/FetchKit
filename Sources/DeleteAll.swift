//
//  DeleteAll.swift
//  FetchKit
//
//  Created by Anton Agarunov on 23.04.17.
//
//

import CoreData
import Foundation

open class deleteAll<ModelType: NSManagedObject>: FetchRequest<ModelType> {
    
    /// Executes fetch request with selected options on given managed object context.
    /// Deletes `ModelType` objects from persistent store and returns deleted objects count.
    ///
    /// - parameter context: Managed object context instance
    ///
    /// - returns: Deleted `ModelType` objects count
    ///
    /// - throws: Core Data error if fetch fails
    @discardableResult
    open func execute(in context: NSManagedObjectContext) throws -> Int {
        let request: NSFetchRequest<ModelType> = fetchRequest()
        request.returnsObjectsAsFaults = true
        request.includesPropertyValues = false
        
        let result = try context.fetch(request)
        for obj in result {
            context.delete(obj)
        }
        return result.count
    }
    
}
