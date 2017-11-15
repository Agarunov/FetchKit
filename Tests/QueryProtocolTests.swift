//
//  QueryProtocolTests.swift
//  FetchKit
//
//  Created by Anton Agarunov on 15.06.17.
//
//

import CoreData
@testable import FetchKit
import XCTest

// swiftlint:disable force_cast force_try force_unwrapping

internal class QueryProtocolTests: FetchKitTests {

    func testFindFirst() {
        let user = try! User.findFirst()
            .sorted(by: #keyPath(User.firstName))
            .execute(in: context)
        XCTAssertEqual(user!.id, 3)
        XCTAssertEqual(user!.firstName, "Alex")
        XCTAssertEqual(user!.lastName, "Finch")
    }
    
    func testFindAll() {
        let all = try! User.findAll().execute(in: context)
        XCTAssertEqual(all.count, 5)
    }
    
    func testFindRange() {
        let users = try! User.findRange(0..<2)
            .sorted(by: #keyPath(User.firstName))
            .sorted(by: #keyPath(User.lastName))
            .execute(in: context)
        
        let alex = users[0]
        let ivan = users[1]
        
        XCTAssertEqual(alex.id, 3)
        XCTAssertEqual(alex.firstName, "Alex")
        XCTAssertEqual(alex.lastName, "Finch")
        
        XCTAssertEqual(ivan.id, 0)
        XCTAssertEqual(ivan.firstName, "Ivan")
        XCTAssertEqual(ivan.lastName, "Ivanov")
    }
    
    func testDeleteAll() {
        let deleteCount = try! User.deleteAll()
            .where(#keyPath(User.firstName), equals: "John")
            .execute(in: context)
        let newCount = try! User.getCount().execute(in: context)
        
        XCTAssertEqual(deleteCount, 2)
        XCTAssertEqual(newCount, 3)
    }
    
    func testAggregate() {
        let result = try! User.aggregate(property: #keyPath(User.id), function: "min:")
            .execute(in: context)
        XCTAssertEqual(result as! Int64, 0)
    }
    
    func testGetMin() {
        let result = try! User.getMin(property: #keyPath(User.id))
            .execute(in: context)
        XCTAssertEqual(result as! Int64, 0)
    }
    
    func testGetMax() {
        let result = try! User.getMax(property: #keyPath(User.id))
            .execute(in: context)
        XCTAssertEqual(result as! Int64, 4)
    }
    
    func testFetchResults() {
        let resultsController = try! User.fetchResults()
            .group(by: #keyPath(User.firstName))
            .sorted(by: #keyPath(User.firstName))
            .sorted(by: #keyPath(User.lastName))
            .execute(in: context)
        XCTAssertEqual(resultsController.fetchedObjects!.count, 5)
        XCTAssertEqual(resultsController.sections!.count, 4)
    }
    
}
