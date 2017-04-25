//
//  AggregateTests.swift
//  FetchKit
//
//  Created by Anton Agarunov on 25.04.17.
//
//

import CoreData
@testable import FetchKit
import XCTest

class AggregateTests: FetchKitTests {
    
    func testInit() {
        var aggreggateRequest = aggregate<User>(property: "id", function: "min:", entityName: "UserEntity")
        XCTAssertEqual(aggreggateRequest.property, "id")
        XCTAssertEqual(aggreggateRequest.function, "min:")
        XCTAssertEqual(aggreggateRequest.entityName, "UserEntity")
        
        aggreggateRequest = aggregate<User>(property: "id", function: "min:")
        XCTAssertEqual(aggreggateRequest.property, "id")
        XCTAssertEqual(aggreggateRequest.function, "min:")
        XCTAssertEqual(aggreggateRequest.entityName, User.fk_entityName)
    }
    
    func testExecuteWithInvalidProperty() {
        let result = try! aggregate<User>(property: "invalid", function: "min:")
            .execute(in: context)
        XCTAssertTrue(result == nil)
    }
    
    func testExecute() {
        let result = try! aggregate<User>(property: #keyPath(User.id), function: "min:")
            .execute(in: context)
        XCTAssertEqual(result as! Int64, 0)
    }

    func testGetMinInit() {
        var minRequest = getMin<User>(property: #keyPath(User.id), entityName: "UserEntity")
        XCTAssertEqual(minRequest.property, "id")
        XCTAssertEqual(minRequest.function, "min:")
        XCTAssertEqual(minRequest.entityName, "UserEntity")

        minRequest = getMin<User>(property: #keyPath(User.id))
        XCTAssertEqual(minRequest.property, "id")
        XCTAssertEqual(minRequest.function, "min:")
        XCTAssertEqual(minRequest.entityName, User.fk_entityName)
        
    }

    func testGetMaxInit() {
        var maxRequest = getMax<User>(property: #keyPath(User.id), entityName: "UserEntity")
        XCTAssertEqual(maxRequest.property, "id")
        XCTAssertEqual(maxRequest.function, "max:")
        XCTAssertEqual(maxRequest.entityName, "UserEntity")
        
        maxRequest = getMax<User>(property: #keyPath(User.id))
        XCTAssertEqual(maxRequest.property, "id")
        XCTAssertEqual(maxRequest.function, "max:")
        XCTAssertEqual(maxRequest.entityName, User.fk_entityName)
        
    }
    
}
