//
//  SaveAccessDelete.swift
//  ShoutOutTests
//
//  Created by Sajjad Patel on 2018-04-03.
//  Copyright © 2018 pluralsight. All rights reserved.
//

import XCTest
import CoreData

@testable import ShoutOut

class SaveAccessDelete: XCTestCase {
    var managedObjectContext: NSManagedObjectContext!
    var dataService: DataService!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.managedObjectContext = createMainContextInMemory()
        self.dataService = DataService(managedObjectContext: self.managedObjectContext)
        self.dataService.seedEmployees()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testFetchAllEmployees() {
        dataService.seedEmployees()
        let employeeFetchRequest = NSFetchRequest<Employee>(entityName: Employee.entityName)
        do {
            let employees = try managedObjectContext.fetch(employeeFetchRequest)
            print(employees)
        } catch {
            print("Something went wrong: \(error)")
        }
    }
    
    func testFilterShoutOuts() {
        dataService.seedEmployees()
        
        seedShoutOutsForTesting(managedObjectContext: managedObjectContext)
        
        let shoutOutFetchRequest = NSFetchRequest<ShoutOut>(entityName: ShoutOut.entityName)
        let shoutOutEqualityPredicate = NSPredicate(format: "%K == %@", #keyPath(ShoutOut.shoutCategory), "Great Job")
        shoutOutFetchRequest.predicate = shoutOutEqualityPredicate
        
        do {
            let filteredShoutOut = try managedObjectContext.fetch(shoutOutFetchRequest)
            print("------First Results------")
            printShoutOuts(shoutOuts: filteredShoutOut)
        } catch {
            print("Something went wrong fetching ShoutOuts: \(error)")
        }
        
        let shoutOutINPredicate = NSPredicate(format: "%K IN %@", #keyPath(ShoutOut.shoutCategory), "Great Job, Well Done!")
        shoutOutFetchRequest.predicate = shoutOutINPredicate
        
        do {
            let filteredShoutOut = try managedObjectContext.fetch(shoutOutFetchRequest)
            print("------Second Results------")
            printShoutOuts(shoutOuts: filteredShoutOut)
        } catch {
            print("Something went wrong fetching ShoutOuts: \(error)")
        }
        
        let beginsWithPredicate = NSPredicate(format: "%K BEGINSWITH %@", #keyPath(ShoutOut.toEmployee.lastName), "Rodrig")
        shoutOutFetchRequest.predicate = beginsWithPredicate
        
        do {
            let filteredShoutOut = try managedObjectContext.fetch(shoutOutFetchRequest)
            print("------Third Results------")
            printShoutOuts(shoutOuts: filteredShoutOut)
        } catch {
            print("Something went wrong fetching ShoutOuts: \(error)")
        }
    }
    
    func seedShoutOutsForTesting(managedObjectContext: NSManagedObjectContext) {
        let employeeFetchRequest = NSFetchRequest<Employee>(entityName: Employee.entityName)
        
        do {
            let employees = try managedObjectContext.fetch(employeeFetchRequest)
            
            let shoutOut1 = NSEntityDescription.insertNewObject(forEntityName: ShoutOut.entityName, into: managedObjectContext) as! ShoutOut
            shoutOut1.shoutCategory = "Great Job"
            shoutOut1.message = "Hey, great job on that project!"
            shoutOut1.toEmployee = employees[0]
            
            let shoutOut2 = NSEntityDescription.insertNewObject(forEntityName: ShoutOut.entityName, into: managedObjectContext) as! ShoutOut
            shoutOut2.shoutCategory = "Great Job"
            shoutOut2.message = "Couldn't have presented better at the conference last week!"
            shoutOut2.toEmployee = employees[1]
            
            let shoutOut3 = NSEntityDescription.insertNewObject(forEntityName: ShoutOut.entityName, into: managedObjectContext) as! ShoutOut
            shoutOut3.shoutCategory = "Awesome Work!"
            shoutOut3.message = "You always do awesome work!"
            shoutOut3.toEmployee = employees[2]
            
            let shoutOut4 = NSEntityDescription.insertNewObject(forEntityName: ShoutOut.entityName, into: managedObjectContext) as! ShoutOut
            shoutOut4.shoutCategory = "Awesome Work!"
            shoutOut4.message = "You've done an amazing job this year!"
            shoutOut4.toEmployee = employees[3]
            
            let shoutOut5 = NSEntityDescription.insertNewObject(forEntityName: ShoutOut.entityName, into: managedObjectContext) as! ShoutOut
            shoutOut5.shoutCategory = "Well Done!"
            shoutOut5.message = "I'm impressed with the results of your prototype!"
            shoutOut5.toEmployee = employees[4]
            
            let shoutOut6 = NSEntityDescription.insertNewObject(forEntityName: ShoutOut.entityName, into: managedObjectContext) as! ShoutOut
            shoutOut6.shoutCategory = "Well Done!"
            shoutOut6.message = "Keep up the good work!"
            shoutOut6.toEmployee = employees[5]
            
            do {
                try managedObjectContext.save()
            } catch {
                print("Something went wrong with saving ShoutOuts: \(error)")
                managedObjectContext.rollback()
            }
        } catch {
            print("Something went wrong fetching employees: \(error)")
        }
    }
    
    func testSortShoutOuts() {
        seedShoutOutsForTesting(managedObjectContext: managedObjectContext)
        
        let shoutOutRequests = NSFetchRequest<ShoutOut>(entityName: ShoutOut.entityName)
        
        do {
            let shoutOuts = try managedObjectContext.fetch(shoutOutRequests)
            print("---------Unsorted ShoutOuts------------")
            printShoutOuts(shoutOuts: shoutOuts)
        } catch _ {}
        
        let shoutCategorySortDescriptor = NSSortDescriptor(key: #keyPath(ShoutOut.shoutCategory), ascending: true)
        let lastNameSortDescriptor = NSSortDescriptor(key: #keyPath(ShoutOut.toEmployee.lastName), ascending: true)
        let firstNameSortDescriptor = NSSortDescriptor(key: #keyPath(ShoutOut.toEmployee.firstName), ascending: true)
        
        shoutOutRequests.sortDescriptors = [shoutCategorySortDescriptor, lastNameSortDescriptor, firstNameSortDescriptor]
        
        do {
            let shoutOuts = try managedObjectContext.fetch(shoutOutRequests)
            print("---------Sorted ShoutOuts------------")
            printShoutOuts(shoutOuts: shoutOuts)
        } catch _ {}
    }
    
    func printShoutOuts(shoutOuts: [ShoutOut]) {
        for shoutOuts in shoutOuts {
            print("---------ShoutOut---------")
            print("Shout Category: \(shoutOuts.shoutCategory)")
            print("Message: \(shoutOuts.message!)")
            print("To: \(shoutOuts.toEmployee.firstName) \(shoutOuts.toEmployee.lastName)")
        }
    }
}
