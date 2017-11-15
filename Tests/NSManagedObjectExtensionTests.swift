//
//  NSManagedObjectExtensionTests.swift
//  FetchKit
//
//  Created by Anton Agarunov on 25.04.17.
//
//

@testable import FetchKit
import XCTest

internal class NSManagedObjectExtensionTests: XCTestCase {
    
    func testEntityName() {
        XCTAssertEqual(User.fk_entityName, "User")
    }
    
}
