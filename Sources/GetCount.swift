//
//  Count.swift
//  FetchKit
//
//  Created by Anton Agarunov on 22.04.17.
//
//

import CoreData
import Foundation

open class getCount<ModelType: NSManagedObject>: FetchRequest<ModelType> {
    
    /// Executes fetch request with selected options on given managed object context.
    /// Returns stored `ModelType` objects count.
    ///
    /// - parameter context: Managed object context instance
    ///
    /// - returns: Stored `ModelType` objects count
    ///
    /// - throws: Core Data error if fetch fails
    open func execute(in context: NSManagedObjectContext) throws -> Int {
        let request: NSFetchRequest<ModelType> = fetchRequest()
        return try context.count(for: request)
    }
    
}
