//
//  GetDistinctTests.swift
//  FetchKit
//
//  Created by Anton Agarunov on 20.11.2017.
//

import CoreData
@testable import FetchKit
import XCTest

internal class GetDistinctTests: FetchKitTests {

    func testInit() {
        let request = GetDistinct<User>()
        XCTAssertNil(request.propertiesToGroupBy)
        XCTAssertTrue(request.aggregations.isEmpty)
        XCTAssertNil(request.havingPredicate)
    }

    func testGroupByString() {
        let request = GetDistinct<User>().group(by: #keyPath(User.firstName))
        XCTAssertEqual(request.propertiesToGroupBy!, [#keyPath(User.firstName)])
    }

    func testGroupByStringArray() {
        let request = GetDistinct<User>().group(by: [#keyPath(User.firstName)])
        XCTAssertEqual(request.propertiesToGroupBy!, [#keyPath(User.firstName)])
    }

    func testGroupByKeyPath() {
        let request = GetDistinct<User>().group(by: \User.firstName)
        XCTAssertEqual(request.propertiesToGroupBy!, [#keyPath(User.firstName)])
    }

    func testGroupByKeyPathArray() {
        let request = GetDistinct<User>().group(by: [\User.firstName])
        XCTAssertEqual(request.propertiesToGroupBy!, [#keyPath(User.firstName)])
    }

    func testAggregateProperty() {
        let request = GetDistinct<User>()
            .aggregate(property: #keyPath(User.id), function: "min:", saveAs: "minId")
        let aggregation = request.aggregations[0]
        XCTAssertEqual(aggregation.property, #keyPath(User.id))
        XCTAssertEqual(aggregation.function, "min:")
        XCTAssertEqual(aggregation.name, "minId")
    }

    func testAggregateKeyPath() {
        let request = GetDistinct<User>()
            .aggregate(keyPath: \User.id, function: "min:", saveAs: "minId")
        let aggregation = request.aggregations[0]
        XCTAssertEqual(aggregation.property, #keyPath(User.id))
        XCTAssertEqual(aggregation.function, "min:")
        XCTAssertEqual(aggregation.name, "minId")
    }

    func testHavingPredicate() {
        let predicate = NSPredicate(format: "id != 0")
        let request = GetDistinct<User>().having(predicate)
        XCTAssertEqual(request.havingPredicate, predicate)
    }

    // swiftlint:disable force_try

    func testExecuteAggregate() {
        let result = try! GetDistinct<User>()
            .aggregate(keyPath: \User.salary, function: "sum:", saveAs: "totalSalary")
            .execute(in: context)
        let nsdicts = result.map { NSDictionary(dictionary: $0) }
        let expected: [NSDictionary] = [["totalSalary": 77_000]]
        XCTAssertEqual(nsdicts, expected)
    }

    func testExecuteGroupBy() {
        let result = try! GetDistinct<User>()
            .propertiesToFetch([\User.firstName])
            .group(by: \User.firstName)
            .execute(in: context)

        let nsdicts = result.map { NSDictionary(dictionary: $0) }
        let expected: [NSDictionary] =
            [["firstName": "Alex"], ["firstName": "Ivan"], ["firstName": "Joe"], ["firstName": "John"]]
        XCTAssertEqual(nsdicts, expected)
    }

    func testExecuteWithInvalidAggragationProperty() {
        let result = try! GetDistinct<User>()
            .propertiesToFetch([\User.firstName])
            .group(by: \User.firstName)
            .aggregate(property: "invalid", function: "sum:", saveAs: "totalSalary")
            .execute(in: context)
        let nsdicts = result.map { NSDictionary(dictionary: $0) }
        let expected: [NSDictionary] =
            [["firstName": "Alex"], ["firstName": "Ivan"], ["firstName": "Joe"], ["firstName": "John"]]
        XCTAssertEqual(nsdicts, expected)
    }

}
