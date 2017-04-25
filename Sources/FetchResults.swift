//
//  FetchResults.swift
//  FetchKit
//
//  Created by Anton Agarunov on 24.04.17.
//
//

import CoreData
import Foundation

@available(OSX 10.12, *)
open class fetchResults<ModelType: NSManagedObject>: FetchRequest<ModelType> {
    
    open internal(set) var groupByKeyPath: String?
    
    open func group(by keyPath: String?) -> Self {
        groupByKeyPath = keyPath
        return self
    }
    
    open func execute(in context: NSManagedObjectContext) throws -> NSFetchedResultsController<ModelType> {
        let request: NSFetchRequest<ModelType> = fetchRequest()
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
