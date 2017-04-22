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
    
    open func execute(in context: NSManagedObjectContext) throws -> ModelType? {
        let request: NSFetchRequest<ModelType> = fetchRequest()
        request.fetchLimit = 1
        let result = try context.fetch(request)
        return result.first
    }
    
}