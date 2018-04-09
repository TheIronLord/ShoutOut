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
            let employees = try self.managedObjectContext.fetch(employeeFetchRequest)
            let employeesAlreadySeeded = employees.count > 0
            if(!employeesAlreadySeeded) {
                let Employee1 = NSEntityDescription.insertNewObject(forEntityName: Employee.entityName, into: self.managedObjectContext) as! Employee
                Employee1.firstName = "Jane"
                Employee1.lastName = "Sherman"
                Employee1.department = "Accounting"
                
                let Employee2 = NSEntityDescription.insertNewObject(forEntityName: Employee.entityName, into: self.managedObjectContext) as! Employee
                Employee2.firstName = "Luke"
                Employee2.lastName = "Jones"
                Employee2.department = "Accounting"
                
                let Employee3 = NSEntityDescription.insertNewObject(forEntityName: Employee.entityName, into: self.managedObjectContext) as! Employee
                Employee3.firstName = "Kathy"
                Employee3.lastName = "Smith"
                Employee3.department = "Information Technology"
                
                let Employee4 = NSEntityDescription.insertNewObject(forEntityName: Employee.entityName, into: self.managedObjectContext) as! Employee
                Employee4.firstName = "Jerome"
                Employee4.lastName = "Rodriguez"
                Employee4.department = "Information Technology"
                
                let Employee5 = NSEntityDescription.insertNewObject(forEntityName: Employee.entityName, into: self.managedObjectContext) as! Employee
                Employee5.firstName = "Maria"
                Employee5.lastName = "Tillman"
                Employee5.department = "Legal"
                
                let Employee6 = NSEntityDescription.insertNewObject(forEntityName: Employee.entityName, into: self.managedObjectContext) as! Employee
                Employee6.firstName = "Paul"
                Employee6.lastName = "O'Brian"
                Employee6.department = "Legal"
                
                do {
                    try self.managedObjectContext.save()
                } catch {
                    print("Something went wrong: \(error)")
                    self.managedObjectContext.rollback()
                }
            } else {
                for employee in employees {
                    switch employee.lastName {
                    case "Sherman":
                        employee.department = "Accounting"
                    case "Jones":
                        employee.department = "Accounting"
                    case "Smith":
                        employee.department = "Information Technology"
                    case "Rodriguez":
                        employee.department = "Information Technology"
                    case "Tillman":
                        employee.department = "Legal"
                    case "O'Brian":
                        employee.department = "Legal"
                    default:
                        break
                    }
                }
                do {
                    try self.managedObjectContext.save()
                } catch _ {}
            }
            
        } catch _ {}
    }
}
