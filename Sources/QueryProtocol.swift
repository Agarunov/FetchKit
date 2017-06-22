//
//  QueryProtocol.swift
//  FetchKit
//
//  Created by Anton Agarunov on 15.06.17.
//
//

import CoreData
import Foundation

protocol QueryProtocol {
    
    associatedtype QueryModelType: NSManagedObject
    
    static func findFirst() -> FindFirst<QueryModelType>
    
    static func findAll() -> FindAll<QueryModelType>
    
    static func findRange(_ range: Range<Int>) -> FindRange<QueryModelType>
    
    static func deleteAll() -> DeleteAll<QueryModelType>

    static func getCount() -> GetCount<QueryModelType>
    
    static func aggregate(property: String, function: String) -> Aggregate<QueryModelType>
    
    static func getMin(property: String) -> GetMin<QueryModelType>
    
    static func getMax(property: String) -> GetMax<QueryModelType>
    
    @available(macOS 10.12, *)
    static func fetchResults() -> FetchResults<QueryModelType>
    
}

extension QueryProtocol where Self: NSManagedObject {
    
    static func findFirst() -> FindFirst<Self> {
        return FindFirst()
    }
    
    static func findAll() -> FindAll<Self> {
        return FindAll()
    }
    
    static func findRange(_ range: Range<Int>) -> FindRange<Self> {
        return FindRange(range)
    }
    
    static func getCount() -> GetCount<Self> {
        return GetCount()
    }
    
    static func deleteAll() -> DeleteAll<Self> {
        return DeleteAll()
    }

    static func aggregate(property: String, function: String) -> Aggregate<Self> {
        return Aggregate(property: property, function: function)
    }
    
    static func getMin(property: String) -> GetMin<Self> {
        return GetMin(property: property)
    }
    
    static func getMax(property: String) -> GetMax<Self> {
        return GetMax(property: property)
    }
    
    @available(macOS 10.12, *)
    static func fetchResults() -> FetchResults<Self> {
        return FetchResults()
    }
    
}
