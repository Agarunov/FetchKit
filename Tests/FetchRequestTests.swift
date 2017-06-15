//
//  FetchRequestTests.swift
//  FetchKit
//
//  Created by Anton Agarunov on 25.04.17.
//
//

import CoreData
@testable import FetchKit
import XCTest

class FetchRequestTests: FetchKitTests {
    
    var fetchRequest: FetchRequest<User>!
    
    override func setUp() {
        super.setUp()
        
        fetchRequest = FetchRequest()
    }
    
    func testFetchRequestInit() {
        XCTAssertEqual(fetchRequest.entityName, User.fk_entityName)
        
        let newRequest = FetchRequest<User>(entityName: "UserEntity")
        XCTAssertEqual(newRequest.entityName, "UserEntity")
    }

    func testSortedByKey() {
        _ = fetchRequest.sorted(by: "firstName")
        XCTAssertEqual(fetchRequest.sortDescriptors,
                       [NSSortDescriptor(key: "firstName", ascending: true)])
        
        _ = fetchRequest.sorted(by: "lastName", ascending: false)
        XCTAssertEqual(fetchRequest.sortDescriptors,
                       [NSSortDescriptor(key: "firstName", ascending: true),
                        NSSortDescriptor(key: "lastName", ascending: false)])
    }
    
    func testSortedByKeyPath() {
        _ = fetchRequest.sorted(by: \User.firstName)
        XCTAssertEqual(fetchRequest.sortDescriptors,
                       [NSSortDescriptor(key: "firstName", ascending: true)])
        
        _ = fetchRequest.sorted(by: \User.lastName, ascending: false)
        XCTAssertEqual(fetchRequest.sortDescriptors,
                       [NSSortDescriptor(key: "firstName", ascending: true),
                        NSSortDescriptor(key: "lastName", ascending: false)])
    }
    
    func testSortedBySortDescriptor() {
        let firstNameSortDescriptor = NSSortDescriptor(key: "firstName", ascending: true)
        _ = fetchRequest.sorted(by: firstNameSortDescriptor)
        XCTAssertEqual(fetchRequest.sortDescriptors, [firstNameSortDescriptor])
        
        let lastNameSortDescriptor = NSSortDescriptor(key: "lastName", ascending: true)
        _ = fetchRequest.sorted(by: lastNameSortDescriptor)
        XCTAssertEqual(fetchRequest.sortDescriptors, [firstNameSortDescriptor, lastNameSortDescriptor])
    }
    
    func testFilteredByPredicate() {
        let idPredicate = NSPredicate(format: "id > 3")
        _ = fetchRequest.filtered(by: idPredicate)
        XCTAssertEqual(fetchRequest.filterPredicate, idPredicate)
        
        let namePredicate = NSPredicate(format: "firstName == John")
        _ = fetchRequest.filtered(by: namePredicate)
        XCTAssertEqual(fetchRequest.filterPredicate, NSPredicate(format: "id > 3 AND firstName == John"))
    }
    
    func testWhereAttributeEquals() {
        _ = fetchRequest.where("firstName", equals: "John")
        XCTAssertEqual(fetchRequest.filterPredicate, NSPredicate(format: "firstName == \"John\""))
    }
    
    func testWhereKeyPathEquals() {
        _ = fetchRequest.where(\User.firstName, equals: "John")
        XCTAssertEqual(fetchRequest.filterPredicate, NSPredicate(format: "firstName == \"John\""))
    }
    
    func testPropertiesToFetch() {
        _ = fetchRequest.propertiesToFetch(["firstName"])
        XCTAssertEqual(fetchRequest.propertiesToFetch!, ["firstName"])
    }

    func testBuildEmptyFetchRequest() {
        let request: NSFetchRequest<User> = fetchRequest.buildFetchRequest()
        XCTAssertEqual(request.entityName, User.fk_entityName)
        XCTAssertEqual(request.sortDescriptors ?? [], [])
        XCTAssertTrue(request.predicate == nil)
        XCTAssertTrue(request.propertiesToFetch == nil)
    }
    
    func testBuildFetchRequest() {
        let sortDescriptor = NSSortDescriptor(key: "firstName", ascending: true)
        let predicate = NSPredicate(format: "firstName == John")
        
        let fetchRequest = FetchRequest<User>(entityName: "UserEntity")
        let request: NSFetchRequest<User> = fetchRequest
            .sorted(by: sortDescriptor)
            .filtered(by: predicate)
            .propertiesToFetch(["id"])
            .buildFetchRequest()
        XCTAssertEqual(request.entityName, "UserEntity")
        XCTAssertEqual(request.sortDescriptors!, [sortDescriptor])
        XCTAssertEqual(request.predicate, predicate)
        XCTAssertEqual(request.propertiesToFetch as! [String], ["id"])
    }
    
}
