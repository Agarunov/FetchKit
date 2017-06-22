//
//  FindRange.swift
//  FetchKit
//
//  Created by Anton Agarunov on 22.04.17.
//
//

import CoreData
import Foundation

open class FindRange<ModelType: NSManagedObject>: FetchRequest<ModelType> {
    
    // MARK: - Properties
    
    /// Fetch range. Sets `NSFetchRequest` `fetchLimit` and `fetchOffset`
    open let range: Range<Int>
    
    // MARK: - Init
    
    /// Initializes a fetch request configured with a given range and entity name
    ///
    /// - parameter range: Fetch range. Sets `NSFetchRequest` `fetchLimit` and `fetchOffset`
    /// - parameter entityName: The name of the entity the request is configured to fetch.
    public init(_ range: Range<Int>, entityName: String = ModelType.fk_entityName) {
        self.range = range
        super.init(entityName: entityName)
    }
    
    // MARK: - Methods
    
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
        request.fetchOffset = range.lowerBound
        request.fetchLimit = range.upperBound - range.lowerBound
        
        return try context.fetch(request)
    }
    
}
