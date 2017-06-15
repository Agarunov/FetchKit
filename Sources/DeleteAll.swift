//
//  DeleteAll.swift
//  FetchKit
//
//  Created by Anton Agarunov on 23.04.17.
//
//

import CoreData
import Foundation

open class DeleteAll<ModelType: NSManagedObject>: FetchRequest<ModelType> {
    
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
        if #available(iOS 9.0, tvOS 9.0, watchOS 2.0, macOS 10.11, *) {
            let request: NSFetchRequest<NSFetchRequestResult> = buildFetchRequest()
            let batchRequest = NSBatchDeleteRequest(fetchRequest: request)
            batchRequest.resultType = .resultTypeCount
            
            guard let batchResult = try context.execute(batchRequest) as? NSBatchDeleteResult,
                let count = batchResult.result as? Int else {
                    fatalError("Invalid context execution result type")
            }
            
            return count
        } else {
            let request: NSFetchRequest<ModelType> = buildFetchRequest()
            request.returnsObjectsAsFaults = true
            request.includesPropertyValues = false
            
            let result = try context.fetch(request)
            for obj in result {
                context.delete(obj)
            }
            
            return result.count
        }
    }
    
}
