//
//  Count.swift
//  FetchKit
//
//  Created by Anton Agarunov on 22.04.17.
//
//

import CoreData
import Foundation

open class count<ModelType: NSManagedObject>: FetchRequest<ModelType> {
    
    open func execute(in context: NSManagedObjectContext) throws -> Int {
        let request: NSFetchRequest<ModelType> = fetchRequest()
        return try context.count(for: request)
    }
    
}
