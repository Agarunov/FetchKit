//
//  GetDistinct.swift
//  FetchKit
//
//  Created by Anton Agarunov on 15.11.2017.
//
//

import CoreData
import Foundation

open class GetDistinct<ModelType: NSManagedObject>: FetchRequest<ModelType> {

    public typealias Aggregation = (property: String, function: String, name: String)

    /// Properties that will be used to group result
    open internal(set) var propertiesToGroupBy: [String]?

    /// Aggregation data which will be used to form aggregation expressions
    open internal(set) var aggregations: [Aggregation] = []

    /// Predicate that will be used to filter result
    open internal(set) var havingPredicate: NSPredicate?

    // MARK: - Methods

    /// Sets property that will be used to group result
    ///
    /// - parameter keyPath: Property keyPath
    ///
    /// - returns: Updated `GetDistinct` instance
    open func group(by keyPath: String) -> Self {
        propertiesToGroupBy = [keyPath]
        return self
    }

    /// Sets properties that will be used to group result
    ///
    /// - parameter keyPaths: Property keyPaths
    ///
    /// - returns: Updated `GetDistinct` instance
    open func group(by keyPaths: [String]) -> Self {
        propertiesToGroupBy = keyPaths
        return self
    }

    /// Sets property that will be used to group result
    ///
    /// - parameter keyPath: Property keyPath
    ///
    /// - returns: Updated `GetDistinct` instance
    open func group(by keyPath: PartialKeyPath<ModelType>) -> Self {
        propertiesToGroupBy = [keyPath._kvcKeyPathString!]
        return self
    }

    /// Sets properties that will be used to group result
    ///
    /// - parameter keyPaths: Property keyPaths
    ///
    /// - returns: Updated `GetDistinct` instance
    open func group(by keyPaths: [PartialKeyPath<ModelType>]) -> Self {
        propertiesToGroupBy = keyPaths.flatMap { $0._kvcKeyPathString }
        return self
    }

    /// Add aggregation function and property to fetch request
    ///
    /// - parameter property: Aggregation property
    /// - parameter function: Aggregation function
    /// - parameter name: Key name which will be used in result dictionary
    ///
    /// - returns: Updated `GetDistinct` instance
    open func aggregate(property: String, function: String, saveAs name: String) -> Self {
        aggregations.append((property: property, function: function, name: name))
        return self
    }

    /// Add aggregation function and keyPath to fetch request
    ///
    /// - parameter keyPath: Aggregation keyPath
    /// - parameter function: Aggregation function
    /// - parameter name: Key name which will be used in result dictionary
    ///
    /// - returns: Updated `GetDistinct` instance
    open func aggregate(keyPath: PartialKeyPath<ModelType>, function: String, saveAs name: String) -> Self {
        aggregations.append((property: keyPath._kvcKeyPathString!, function: function, name: name))
        return self
    }

    /// Sets predicate that will be used to filter result
    ///
    /// - parameter predicate: Filter preficate
    ///
    /// - returns: Updated `GetDistinct` instance
    open func having(_ predicate: NSPredicate) -> Self {
        havingPredicate = predicate
        return self
    }

    /// Executes fetch request with selected options on given managed object context.
    /// Returns fetched properties and aggregation results
    ///
    /// - parameter context: Managed object context instance
    ///
    /// - returns: Fetched properties and aggregation results
    ///
    /// - throws: Core Data error if fetch fails
    open func execute(in context: NSManagedObjectContext) throws -> [[String: Any]] {
        let request: NSFetchRequest<NSDictionary> = buildFetchRequest()
        request.resultType = .dictionaryResultType
        request.returnsDistinctResults = true
        request.havingPredicate = havingPredicate
        request.propertiesToGroupBy = propertiesToGroupBy

        let entityDescription = NSEntityDescription.entity(forEntityName: entityName, in: context)
        let expressions = aggregations.flatMap { aggregation -> NSExpressionDescription? in
            guard let attributeDescription = entityDescription?.attributeDescription(for: aggregation.property) else {
                return nil
            }
            let expression = NSExpression(forFunction: aggregation.function,
                                          arguments: [NSExpression(forKeyPath: aggregation.property)])
            let expressionDescription = NSExpressionDescription()
            expressionDescription.name = aggregation.name
            expressionDescription.expression = expression
            expressionDescription.expressionResultType = attributeDescription.attributeType

            return expressionDescription
        }

        if let propertiesToFetch = request.propertiesToFetch {
            request.propertiesToFetch = propertiesToFetch + expressions
        } else {
            request.propertiesToFetch = expressions
        }

        let result = try context.fetch(request)
        return result as? [[String: Any]] ?? []
    }

}
