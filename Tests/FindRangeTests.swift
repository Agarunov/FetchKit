//
//  FindRangeTests.swift
//  FetchKit
//
//  Created by Anton Agarunov on 25.04.17.
//
//

import CoreData
@testable import FetchKit
import XCTest

class FindRangeTests: FetchKitTests {
    
    func testInit() {
        var findRangeRequest = FindRange<User>(0..<2, entityName: "UserEntity")
        XCTAssertEqual(findRangeRequest.entityName, "UserEntity")
        XCTAssertEqual(findRangeRequest.range, 0..<2)
        
        findRangeRequest = FindRange<User>(0..<2)
        XCTAssertEqual(findRangeRequest.entityName, User.fk_entityName)
        XCTAssertEqual(findRangeRequest.range, 0..<2)

    }
    
    func testExecute() {
        let users = try! FindRange<User>(0..<2)
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
    
}
