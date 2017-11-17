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

// swiftlint:disable force_cast force_try

internal class AggregateTests: FetchKitTests {
    
    func testInitWithProperty() {
        var aggreggateRequest = Aggregate<User>(property: #keyPath(User.id), function: "min:", entityName: "UserEntity")
        XCTAssertEqual(aggreggateRequest.property, "id")
        XCTAssertEqual(aggreggateRequest.function, "min:")
        XCTAssertEqual(aggreggateRequest.entityName, "UserEntity")
        
        aggreggateRequest = Aggregate<User>(property: #keyPath(User.id), function: "min:")
        XCTAssertEqual(aggreggateRequest.property, "id")
        XCTAssertEqual(aggreggateRequest.function, "min:")
        XCTAssertEqual(aggreggateRequest.entityName, User.fk_entityName)
    }

    func testInitWithKeyPath() {
        var aggreggateRequest = Aggregate<User>(keyPath: \User.id, function: "min:", entityName: "UserEntity")
        XCTAssertEqual(aggreggateRequest.property, "id")
        XCTAssertEqual(aggreggateRequest.function, "min:")
        XCTAssertEqual(aggreggateRequest.entityName, "UserEntity")

        aggreggateRequest = Aggregate<User>(keyPath: \User.id, function: "min:")
        XCTAssertEqual(aggreggateRequest.property, "id")
        XCTAssertEqual(aggreggateRequest.function, "min:")
        XCTAssertEqual(aggreggateRequest.entityName, User.fk_entityName)
    }

    func testExecuteWithInvalidProperty() {
        let result = try! Aggregate<User>(property: "invalid", function: "min:")
            .execute(in: context)
        XCTAssertTrue(result == nil)
    }
    
    func testExecute() {
        let result = try! Aggregate<User>(property: #keyPath(User.id), function: "min:")
            .execute(in: context)
        XCTAssertEqual(result as! Int64, 0)
    }

    func testGetMinInitWithProperty() {
        var minRequest = GetMin<User>(property: #keyPath(User.id), entityName: "UserEntity")
        XCTAssertEqual(minRequest.property, "id")
        XCTAssertEqual(minRequest.function, "min:")
        XCTAssertEqual(minRequest.entityName, "UserEntity")

        minRequest = GetMin<User>(property: #keyPath(User.id))
        XCTAssertEqual(minRequest.property, "id")
        XCTAssertEqual(minRequest.function, "min:")
        XCTAssertEqual(minRequest.entityName, User.fk_entityName)
    }

    func testGetMinInitWithKeyPath() {
        var minRequest = GetMin<User>(keyPath: \User.id, entityName: "UserEntity")
        XCTAssertEqual(minRequest.property, "id")
        XCTAssertEqual(minRequest.function, "min:")
        XCTAssertEqual(minRequest.entityName, "UserEntity")

        minRequest = GetMin<User>(keyPath: \User.id)
        XCTAssertEqual(minRequest.property, "id")
        XCTAssertEqual(minRequest.function, "min:")
        XCTAssertEqual(minRequest.entityName, User.fk_entityName)
    }

    func testGetMaxInitWithProperty() {
        var maxRequest = GetMax<User>(property: #keyPath(User.id), entityName: "UserEntity")
        XCTAssertEqual(maxRequest.property, "id")
        XCTAssertEqual(maxRequest.function, "max:")
        XCTAssertEqual(maxRequest.entityName, "UserEntity")
        
        maxRequest = GetMax<User>(property: #keyPath(User.id))
        XCTAssertEqual(maxRequest.property, "id")
        XCTAssertEqual(maxRequest.function, "max:")
        XCTAssertEqual(maxRequest.entityName, User.fk_entityName)
    }

    func testGetMaxInitWithKeyPath() {
        var maxRequest = GetMax<User>(keyPath: \User.id, entityName: "UserEntity")
        XCTAssertEqual(maxRequest.property, "id")
        XCTAssertEqual(maxRequest.function, "max:")
        XCTAssertEqual(maxRequest.entityName, "UserEntity")

        maxRequest = GetMax<User>(keyPath: \User.id)
        XCTAssertEqual(maxRequest.property, "id")
        XCTAssertEqual(maxRequest.function, "max:")
        XCTAssertEqual(maxRequest.entityName, User.fk_entityName)
    }

}
