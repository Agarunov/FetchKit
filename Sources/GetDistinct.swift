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

    open internal(set) var propertiesToGroupBy: [String]?

    open internal(set) var aggregations: [Aggregation] = []

    open internal(set) var havingPredicate: NSPredicate?

    open func group(by keyPath: String) -> Self {
        propertiesToGroupBy = [keyPath]
        return self
    }

    open func group(by keyPaths: [String]) -> Self {
        propertiesToGroupBy = keyPaths
        return self
    }

    open func group(by keyPath: PartialKeyPath<ModelType>) -> Self {
        propertiesToGroupBy = [keyPath._kvcKeyPathString!]
        return self
    }

    open func group(by keyPaths: [PartialKeyPath<ModelType>]) -> Self {
        propertiesToGroupBy = keyPaths.flatMap { $0._kvcKeyPathString }
        return self
    }

    open func aggregate(property: String, function: String, saveAs name: String) -> Self {
        aggregations.append((property: property, function: function, name: name))
        return self
    }

    open func aggregate(keyPath: PartialKeyPath<ModelType>, function: String, saveAs name: String) -> Self {
        aggregations.append((property: keyPath._kvcKeyPathString!, function: function, name: name))
        return self
    }
    
    open func having(_ predicate: NSPredicate) -> Self {
        havingPredicate = predicate
        return self
    }

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
