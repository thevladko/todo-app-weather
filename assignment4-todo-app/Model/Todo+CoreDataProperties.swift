//
//  Todo+CoreDataProperties.swift
//  assignment4-todo-app
//
//  Created by Vladislav Kobyakov on 7/18/18.
//  Copyright © 2018 Vladislav Kobyakov. All rights reserved.
//
//

import Foundation
import CoreData


extension Todo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todo> {
        return NSFetchRequest<Todo>(entityName: "Todo")
    }

    @NSManaged public var completed: Bool
    @NSManaged public var date: Date?
    @NSManaged public var text: String?

}
