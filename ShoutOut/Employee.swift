//
//  Employee.swift
//  ShoutOut
//
//  Created by Sajjad Patel on 2018-04-02.
//  Copyright © 2018 pluralsight. All rights reserved.
//

import Foundation
import CoreData

class Employee: NSManagedObject {
    @NSManaged var firstName: String
    @NSManaged var lastName: String
    @NSManaged var department: String
    
    @NSManaged var shoutOuts: NSSet?
    
    static var entityName: String { return "Employee" }
}
