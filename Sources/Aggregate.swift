//
//  Aggregate.swift
//  FetchKit
//
//  Created by Anton Agarunov on 22.04.17.
//
//

import CoreData
import Foundation

open class Aggregate<ModelType: NSManagedObject>: FetchRequest<ModelType> {
    
    // MARK: - Properties
    
    /// Fetch aggregation property
    public let property: String
    
    /// Fetch aggregation function
    public let function: String
    
    // MARK: - Init
    
    /// Initializes a fetch request configured with a given aggregation function, property and entity name
    ///
    /// - parameter property: Aggregation property
    /// - parameter function: Aggregation function
    /// - parameter entityName: The name of the entity the request is configured to fetch.
    public init(property: String, function: String, entityName: String = ModelType.fk_entityName) {
        self.property = property
        self.function = function
        super.init(entityName: entityName)
    }

    /// Initializes a fetch request configured with a given aggregation function, keyPath and entity name
    ///
    /// - parameter keyPath: Aggregation keyPath
    /// - parameter function: Aggregation function
    /// - parameter entityName: The name of the entity the request is configured to fetch.
    public convenience init(keyPath: PartialKeyPath<ModelType>,
                            function: String,
                            entityName: String = ModelType.fk_entityName) {
        self.init(property: keyPath._kvcKeyPathString!, function: function, entityName: entityName)
    }

    // MARK: - Methods
    
    /// Executes fetch request with selected options on given managed object context.
    /// Returns aggregate function result or `nil`
    ///
    /// - parameter context: Managed object context instance
    ///
    /// - returns: Aggregate function result or `nil`
    ///
    /// - throws: Core Data error if fetch fails
    open func execute(in context: NSManagedObjectContext) throws -> Any? {
        let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: context)
        guard let attributeDescription = entityDescription?.attributesByName[property] else {
            return nil
        }
        
        let expression = NSExpression(forFunction: function, arguments: [NSExpression(forKeyPath: property)])
        let expressionDescription = NSExpressionDescription()
        expressionDescription.name = "result"
        expressionDescription.expression = expression
        expressionDescription.expressionResultType = attributeDescription.attributeType
        
        let request: NSFetchRequest<NSDictionary> = buildFetchRequest()
        request.resultType = .dictionaryResultType
        request.propertiesToFetch = [expressionDescription]
        
        let dict = try context.fetch(request).first
        return dict?.object(forKey: "result")
    }
    
}

open class GetMin<ModelType: NSManagedObject>: Aggregate<ModelType> {
    
    /// Initializes a fetch request configured with a given aggregation property and entity name.
    /// Sets aggregation function to `"min:"`.
    ///
    /// - parameter property: Aggregation property
    /// - parameter entityName: The name of the entity the request is configured to fetch.
    public init(property: String, entityName: String = ModelType.fk_entityName) {
        super.init(property: property, function: "min:", entityName: entityName)
    }

    /// Initializes a fetch request configured with a given aggregation keyPath and entity name.
    /// Sets aggregation function to `"min:"`.
    ///
    /// - parameter property: Aggregation keyPath
    /// - parameter entityName: The name of the entity the request is configured to fetch.
    public convenience init(keyPath: PartialKeyPath<ModelType>, entityName: String = ModelType.fk_entityName) {
        self.init(property: keyPath._kvcKeyPathString!, entityName: entityName)
    }

}

open class GetMax<ModelType: NSManagedObject>: Aggregate<ModelType> {
    
    /// Initializes a fetch request configured with a given aggregation property and entity name.
    /// Sets aggregation function to `"max:"`.
    ///
    /// - parameter property: Aggregation property
    /// - parameter entityName: The name of the entity the request is configured to fetch.
    public init(property: String, entityName: String = ModelType.fk_entityName) {
        super.init(property: property, function: "max:", entityName: entityName)
    }

    /// Initializes a fetch request configured with a given aggregation keyPath and entity name.
    /// Sets aggregation function to `"max:"`.
    ///
    /// - parameter property: Aggregation keyPath
    /// - parameter entityName: The name of the entity the request is configured to fetch.
    public convenience init(keyPath: PartialKeyPath<ModelType>, entityName: String = ModelType.fk_entityName) {
        self.init(property: keyPath._kvcKeyPathString!, entityName: entityName)
    }
    
}
