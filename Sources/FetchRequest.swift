//
//  FetchRequest.swift
//  FetchKit
//
//  Created by Anton Agarunov on 22.04.17.
//
//

import CoreData
import Foundation

/// Base class for configuring fetch requests
open class FetchRequest<ModelType: NSManagedObject> {
    
    // MARK: - Properties
    
    /// The name of the entity the request is configured to fetch.
    open let entityName: String
    
    /// Sort descriptors used by fetch request
    open internal(set) var sortDescriptors: [NSSortDescriptor]
    
    /// The predicate used by fetch request
    open internal(set) var filterPredicate: NSPredicate?
    
    /// Properties that should be fetched
    open internal(set) var propertiesToFetch: [String]?

    // MARK: - Init
    
    /// Initializes a fetch request configured with a given entity name
    ///
    /// - parameter entityName: The name of the entity the request is configured to fetch.
    public init(entityName: String = ModelType.fk_entityName) {
        self.entityName = entityName
        self.sortDescriptors = []
        self.filterPredicate = nil
        self.propertiesToFetch = nil
    }
    
    // MARK: - Methods
    
    /// Creates new NSSortDescriptor and adds it to receivers `sortDescriptors` array
    ///
    /// - parameter keyPath: Entity's partial keyPath used to sort
    /// - parameter ascending: Ascending sort order if true. Otherwise descending.
    ///
    /// - returns: Updated `FetchRequet` instance
    open func sorted(by keyPath: PartialKeyPath<ModelType>, ascending: Bool = true) -> Self {
        let sortDescriptor = NSSortDescriptor(key: keyPath._kvcKeyPathString!, ascending: ascending)
        return sorted(by: sortDescriptor)
    }
    
    /// Creates new NSSortDescriptor and adds it to receivers `sortDescriptors` array
    ///
    /// - parameter key: Entity's attribute keypath used to sort
    /// - parameter ascending: Ascending sort order if true. Otherwise descending.
    ///
    /// - returns: Updated `FetchRequet` instance
    open func sorted(by key: String, ascending: Bool = true) -> Self {
        let sortDescriptor = NSSortDescriptor(key: key, ascending: ascending)
        return sorted(by: sortDescriptor)
    }
    
    /// Appends receivers `sortDescriptors` array with given sort descriptor
    ///
    /// - parameter sortDescriptor: Sort descriptor
    ///
    /// - returns: Updated `FetchRequet` instance
    open func sorted(by sortDescriptor: NSSortDescriptor) -> Self {
        sortDescriptors.append(sortDescriptor)
        return self
    }
    
    /// Sets given predicate to recievers `filterPredicate` property.
    /// If receiver already contains predicate, then creates NSCompoundPredicate
    /// with current predicate and given one
    ///
    /// - parameter predicate: Predicate
    ///
    /// - returns: Updated `FetchRequet` instance
    open func filtered(by predicate: NSPredicate) -> Self {
        var newPredicate = predicate
        
        if let currentPredicate = filterPredicate {
            newPredicate = NSCompoundPredicate(type: .and, subpredicates: [currentPredicate, predicate])
        }
        
        filterPredicate = newPredicate
        return self
    }
    
    /// Creates NSPredicate with format `"attribute == value"` and updates 
    /// recievers `filterPredicate` property
    ///
    /// - parameter attribute: Entity's attribute keypath
    /// - parameter value: Expected entity's attribute value
    ///
    /// - returns: Updated `FetchRequet` instance
    open func `where`(_ attribute: String, equals value: Any) -> Self {
        let predicate = NSPredicate(format: "%K == %@", argumentArray: [attribute, value])
        return filtered(by: predicate)
    }
    
    /// Creates NSPredicate with format `keyPath == value"` and updates
    /// recievers `filterPredicate` property
    ///
    /// - parameter keyPath: Entity's attribute keypath
    /// - parameter value: Expected entity's attribute value
    ///
    /// - returns: Updated `FetchRequet` instance
    open func `where`<ValueType>(_ keyPath: KeyPath<ModelType, ValueType>, equals value: ValueType) -> Self {
        let predicate = NSPredicate(format: "%K == %@", argumentArray: [keyPath._kvcKeyPathString!, value])
        return filtered(by: predicate)
    }
    
    /// Sets given array to receivers `propertiesToFetch` property
    ///
    /// - parameter properties: Array of properties keypaths
    ///
    /// - returns: Updated `FetchRequet` instance
    open func propertiesToFetch(_ properties: [String]?) -> Self {
        propertiesToFetch = properties
        return self
    }
    
    /// Creates NSFetchRequest instance and configure with current options
    /// This method used by subclasses to get NSFetchRequest and execute fetch
    ///
    /// - returns: Configured NSFetchRequest instance
    open func buildFetchRequest<ResultType>() -> NSFetchRequest<ResultType> {
        let request = NSFetchRequest<ResultType>(entityName: entityName)
        request.sortDescriptors = sortDescriptors
        request.predicate = filterPredicate
        
        if let propertiesToFetch = propertiesToFetch {
            request.propertiesToFetch = propertiesToFetch
        }

        return request
    }
    
}
