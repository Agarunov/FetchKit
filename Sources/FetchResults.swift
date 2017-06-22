//
//  FetchResults.swift
//  FetchKit
//
//  Created by Anton Agarunov on 24.04.17.
//
//

import CoreData
import Foundation

@available(macOS 10.12, *)
open class FetchResults<ModelType: NSManagedObject>: FetchRequest<ModelType> {
    
    // MARK: - Properties
    
    /// Fetched results controller section name keypath
    open internal(set) var groupByKeyPath: String?
    
    // MARK: - Methods
    
    /// Sets receiver `groupByKeyPath` property
    ///
    /// - parameter keyPath: Fetched resuslts controller section name keypath
    ///
    /// - returns: Updated `fetchResults` instance
    open func group(by keyPath: String?) -> Self {
        groupByKeyPath = keyPath
        return self
    }
    
    /// Creates `NSFetchedResultsController` with selected options in given managed object context.
    /// Also perform fetch.
    ///
    /// - parameter context: Managed object context instance
    ///
    /// - returns: created `NSFetchedResultsController<ModelType>`
    ///
    /// - throws: Core Data error if fetch fails
    open func execute(in context: NSManagedObjectContext) throws -> NSFetchedResultsController<ModelType> {
        let request: NSFetchRequest<ModelType> = buildFetchRequest()
        let controller = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: groupByKeyPath,
            cacheName: nil
        )
        
        try controller.performFetch()
        return controller
    }
    
}
