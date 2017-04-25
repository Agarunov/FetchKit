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
