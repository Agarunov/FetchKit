//
//  FetchResultsTests.swift
//  FetchKit
//
//  Created by Anton Agarunov on 25.04.17.
//
//

import CoreData
@testable import FetchKit
import XCTest

// swiftlint:disable force_try force_unwrapping

internal class FetchResultsTests: FetchKitTests {
    
    func testGroupBy() {
        let request = FetchResults<User>()
            .group(by: #keyPath(User.firstName))
        XCTAssertEqual(request.groupByKeyPath, #keyPath(User.firstName))
    }
    
    func testExecute() {
        let resultsController = try! FetchResults<User>()
            .group(by: #keyPath(User.firstName))
            .sorted(by: #keyPath(User.firstName))
            .sorted(by: #keyPath(User.lastName))
            .execute(in: context)
        XCTAssertEqual(resultsController.fetchedObjects!.count, 5)
        XCTAssertEqual(resultsController.sections!.count, 4)
    }
}
