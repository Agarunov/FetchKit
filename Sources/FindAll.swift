//
//  FindAll.swift
//  FetchKit
//
//  Created by Anton Agarunov on 22.04.17.
//
//

import CoreData
import Foundation

open class FindAll<ModelType: NSManagedObject>: FetchRequest<ModelType> {
    
    /// Executes fetch request with selected options on given managed object context.
    /// Returns `ModelType` objects array.
    ///
    /// - parameter context: Managed object context instance
    ///
    /// - returns: Fetched `ModelType` objects array
    ///
    /// - throws: Core Data error if fetch fails
    open func execute(in context: NSManagedObjectContext) throws -> [ModelType] {
        let request: NSFetchRequest<ModelType> = buildFetchRequest()
        return try context.fetch(request)
    }
    
}
