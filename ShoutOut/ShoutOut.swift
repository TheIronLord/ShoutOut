//
//  ShoutOut.swift
//  ShoutOut
//
//  Created by Sajjad Patel on 2018-03-28.
//  Copyright © 2018 pluralsight. All rights reserved.
//

import Foundation
import CoreData

class ShoutOut: NSManagedObject {
    @NSManaged var from: String?
    @NSManaged var message: String?
    @NSManaged var sentDate: Date?
    @NSManaged var shoutCategory: String
}
