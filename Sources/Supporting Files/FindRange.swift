//
//  FindRange.swift
//  FetchKit
//
//  Created by Anton Agarunov on 22.04.17.
//
//

import CoreData
import Foundation

open class findRange<ModelType: NSManagedObject>: FetchRequest<ModelType> {
    
    open let range: Range<Int>
    
    public init(_ range: Range<Int>, entityName: String = ModelType.fk_entityName) {
        self.range = range
        super.init(entityName: entityName)
    }
    
    open func execute(in context: NSManagedObjectContext) throws -> [ModelType] {
        let request: NSFetchRequest<ModelType> = fetchRequest()
        request.fetchOffset = range.lowerBound
        request.fetchLimit = range.upperBound - range.lowerBound
        
        return try context.fetch(request)
    }
    
}
