//
//  DataService.swift
//  ShoutOut
//
//  Created by Sajjad Patel on 2018-04-03.
//  Copyright © 2018 pluralsight. All rights reserved.
//

import Foundation
import CoreData

struct DataService: ManagedObjectContextDependentType {
    
    var managedObjectContext: NSManagedObjectContext!
    
    func seedEmployees() {
        let employeeFetchRequest = NSFetchRequest<Employee>(entityName: Employee.entityName)
        
        do{
            let employeesAlreadySeeded = try self.managedObjectContext.fetch(employeeFetchRequest).count > 0
            if(!employeesAlreadySeeded) {
                let Employee1 = NSEntityDescription.insertNewObject(forEntityName: Employee.entityName, into: self.managedObjectContext) as! Employee
                Employee1.firstName = "Jane"
                Employee1.lastName = "Sherman"
                
                let Employee2 = NSEntityDescription.insertNewObject(forEntityName: Employee.entityName, into: self.managedObjectContext) as! Employee
                Employee2.firstName = "Luke"
                Employee2.lastName = "Jones"
                
                let Employee3 = NSEntityDescription.insertNewObject(forEntityName: Employee.entityName, into: self.managedObjectContext) as! Employee
                Employee3.firstName = "Kathy"
                Employee3.lastName = "Smith"
                
                let Employee4 = NSEntityDescription.insertNewObject(forEntityName: Employee.entityName, into: self.managedObjectContext) as! Employee
                Employee4.firstName = "Jerome"
                Employee4.lastName = "Rodriguez"
                
                let Employee5 = NSEntityDescription.insertNewObject(forEntityName: Employee.entityName, into: self.managedObjectContext) as! Employee
                Employee5.firstName = "Maria"
                Employee5.lastName = "Tillman"
                
                let Employee6 = NSEntityDescription.insertNewObject(forEntityName: Employee.entityName, into: self.managedObjectContext) as! Employee
                Employee6.firstName = "Paul"
                Employee6.lastName = "O'Brian"
            }
            do {
                try self.managedObjectContext.save()
            } catch {
                print("Something went wrong: \(error)")
                self.managedObjectContext.rollback()
            }
        } catch _ {}
    }
}
