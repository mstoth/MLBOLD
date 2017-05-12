//
//  Lesson+CoreDataProperties.swift
//  MLB
//
//  Created by Michael Toth on 4/4/17.
//  Copyright © 2017 Michael Toth. All rights reserved.
//

import Foundation
import CoreData


extension Lesson {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Lesson> {
        return NSFetchRequest<Lesson>(entityName: "Lesson");
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var length: Int32
    @NSManaged public var paid: Bool
    @NSManaged public var rate: Float
    @NSManaged public var student: Student?

}
