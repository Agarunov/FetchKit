//
//  FetchRequest.swift
//  FetchKit
//
//  Created by Anton Agarunov on 22.04.17.
//
//

import CoreData
import Foundation

open class FetchRequest<ModelType: NSManagedObject> {
    
    // MARK: - Properties
    
    open let entityName: String
    
    open internal(set) var sortDescriptors: [NSSortDescriptor]
    
    open internal(set) var filterPredicate: NSPredicate?
    
    open internal(set) var propertiesToFetch: [String]?

    // MARK: - Init
    
    public init(entityName: String = ModelType.fk_entityName) {
        self.entityName = entityName
        self.sortDescriptors = []
        self.filterPredicate = nil
        self.propertiesToFetch = nil
    }
    
    // MARK: - Methods
    
    open func sorted(by key: String, ascending: Bool = true) -> Self {
        let sortDescriptor = NSSortDescriptor(key: key, ascending: ascending)
        return sorted(by: sortDescriptor)
    }
    
    open func sorted(by sortDescriptor: NSSortDescriptor) -> Self {
        sortDescriptors.append(sortDescriptor)
        return self
    }
    
    open func filtered(by predicate: NSPredicate) -> Self {
        var newPredicate = predicate
        
        if let currentPredicate = filterPredicate {
            newPredicate = NSCompoundPredicate(type: .and, subpredicates: [currentPredicate, predicate])
        }
        
        filterPredicate = newPredicate
        return self
    }
    
    open func `where`(_ attribute: String, equals value: Any) -> Self {
        let predicate = NSPredicate(format: "%K == %@", argumentArray: [attribute, value])
        return filtered(by: predicate)
    }
    
    open func propertiesToFetch(_ properties: [String]?) -> Self {
        propertiesToFetch = properties
        return self
    }

    open func fetchRequest<ResultType: NSFetchRequestResult>() -> NSFetchRequest<ResultType> {
        let request = NSFetchRequest<ResultType>(entityName: entityName)
        request.sortDescriptors = sortDescriptors
        request.predicate = filterPredicate
        
        if let propertiesToFetch = propertiesToFetch {
            request.propertiesToFetch = propertiesToFetch
        }

        return request
    }
    
}
