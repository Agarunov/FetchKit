//
//  FetchKitTests.swift
//  FetchKit
//
//  Created by Anton Agarunov on 25.04.17.
//
//

import CoreData
@testable import FetchKit
import XCTest

@objc(User)
class User: NSManagedObject {
    @NSManaged var id: Int64
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
}

class FetchKitTests: XCTestCase {
    
    var model: NSManagedObjectModel!
    var context: NSManagedObjectContext!
    var persistentStore: NSPersistentStore!
    var persistentStoreCoordinator: NSPersistentStoreCoordinator!
    
    override func setUp() {
        super.setUp()
        
        setupModel()
        setupPersistentStoreCoordinator()
        populateDatabase()
    }
    
    override func tearDown() {
        super.tearDown()
        
        // Core Data tear down
        try! persistentStoreCoordinator.remove(persistentStore)
    }
    
    private func setupModel() {
        let userEntity = NSEntityDescription()
        userEntity.name = "User"
        userEntity.managedObjectClassName = "User"
        
        let idAttribute = NSAttributeDescription()
        idAttribute.name = "id"
        idAttribute.isOptional = false
        idAttribute.attributeType = .integer64AttributeType
        
        let firstNameAttribute = NSAttributeDescription()
        firstNameAttribute.name = "firstName"
        firstNameAttribute.isOptional = true
        firstNameAttribute.attributeType = .stringAttributeType
        
        let lastNameAttribute = NSAttributeDescription()
        lastNameAttribute.name = "lastName"
        lastNameAttribute.isOptional = true
        lastNameAttribute.attributeType = .stringAttributeType
        
        userEntity.properties = [idAttribute, firstNameAttribute, lastNameAttribute]

        model = NSManagedObjectModel()
        model.entities = [userEntity]
    }
    
    private func setupPersistentStoreCoordinator() {
        persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        
        do {
            let tmpDirUrl = FileManager.default.temporaryDirectory.appendingPathComponent("test.sqlite")
            if FileManager.default.fileExists(atPath: tmpDirUrl.path) {
                try FileManager.default.removeItem(at: tmpDirUrl)
            }
            FileManager.default.createFile(atPath: tmpDirUrl.path, contents: nil, attributes: nil)
            
            persistentStore = try persistentStoreCoordinator.addPersistentStore(
                ofType: NSSQLiteStoreType,
                configurationName: nil,
                at: tmpDirUrl,
                options: nil
            )
            
            context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            context.persistentStoreCoordinator = persistentStoreCoordinator
            
        } catch {
            print(error)
            XCTFail("Setup persistent store coordiantor error")
        }
    }
    
    private func populateDatabase() {
        let data =
            [("Ivan", "Ivanov"), ("John", "Williams"), ("Joe", "Cole"), ("Alex", "Finch"), ("John", "Donn")]
        
        for (idx, name) in data.enumerated() {
            let user = NSEntityDescription.insertNewObject(
                forEntityName: User.fk_entityName,
                into: context) as! User
            
            user.id = Int64(idx)
            user.firstName = name.0
            user.lastName = name.1
        }
        
        do {
            try context.save()
        } catch {
            print(error)
            XCTFail("Context save error")
        }

    }
    
}
