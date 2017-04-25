//
//  Aggregate.swift
//  FetchKit
//
//  Created by Anton Agarunov on 22.04.17.
//
//

import CoreData
import Foundation

open class aggregate<ModelType: NSManagedObject>: FetchRequest<ModelType> {
    open let property: String
    open let function: String
    
    public init(property: String, function: String, entityName: String = ModelType.fk_entityName) {
        self.property = property
        self.function = function
        super.init(entityName: entityName)
    }
    
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
        
        let request: NSFetchRequest<NSDictionary> = fetchRequest()
        request.resultType = .dictionaryResultType
        request.propertiesToFetch = [expressionDescription]
        
        let dict = try context.fetch(request).first
        return dict?.object(forKey: "result")
    }
}

open class getMin<ModelType: NSManagedObject>: aggregate<ModelType> {
    
    public init(property: String, entityName: String = ModelType.fk_entityName) {
        super.init(property: property, function: "min:", entityName: entityName)
    }
    
}

open class getMax<ModelType: NSManagedObject>: aggregate<ModelType> {
    
    public init(property: String, entityName: String = ModelType.fk_entityName) {
        super.init(property: property, function: "max:", entityName: entityName)
    }
    
}
