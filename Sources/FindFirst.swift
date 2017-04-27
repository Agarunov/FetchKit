//
//  FindFirst.swift
//  FetchKit
//
//  Created by Anton Agarunov on 22.04.17.
//
//

import CoreData
import Foundation

open class findFirst<ModelType: NSManagedObject>: FetchRequest<ModelType> {

    /// Executes fetch request with selected options on given managed object context.
    /// Returns `ModelType` object or `nil` for empty fetch results
    ///
    /// - parameter context: Managed object context instance
    ///
    /// - returns: Fetched `ModelType` object or `nil`
    ///
    /// - throws: Core Data error if fetch fails
    open func execute(in context: NSManagedObjectContext) throws -> ModelType? {
        let request: NSFetchRequest<ModelType> = buildFetchRequest()
        request.fetchLimit = 1
        let result = try context.fetch(request)
        return result.first
    }
    
}
