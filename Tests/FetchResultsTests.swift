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

class FetchResultsTests: FetchKitTests {
    
    func testGroupBy() {
        let request = fetchResults<User>()
            .group(by: #keyPath(User.firstName))
        XCTAssertEqual(request.groupByKeyPath, #keyPath(User.firstName))
    }
    
    func testExecute() {
        let resultsController = try! fetchResults<User>()
            .group(by: #keyPath(User.firstName))
            .sorted(by: #keyPath(User.firstName))
            .sorted(by: #keyPath(User.lastName))
            .execute(in: context)
        XCTAssertEqual(resultsController.fetchedObjects!.count, 5)
        XCTAssertEqual(resultsController.sections!.count, 4)
    }
}
