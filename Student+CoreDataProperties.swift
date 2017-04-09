//
//  Student+CoreDataProperties.swift
//  MLB
//
//  Created by Michael Toth on 4/4/17.
//  Copyright © 2017 Michael Toth. All rights reserved.
//

import Foundation
import CoreData


extension Student {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Student> {
        return NSFetchRequest<Student>(entityName: "Student");
    }

    @NSManaged public var city: String?
    @NSManaged public var email: String?
    @NSManaged public var firstName: String?
    @NSManaged public var image: NSData?
    @NSManaged public var lastName: String?
    @NSManaged public var phone: String?
    @NSManaged public var state: String?
    @NSManaged public var street: String?
    @NSManaged public var zip: String?
    @NSManaged public var lessons: NSSet?

}

// MARK: Generated accessors for lessons
extension Student {

    @objc(addLessonsObject:)
    @NSManaged public func addToLessons(_ value: Lesson)

    @objc(removeLessonsObject:)
    @NSManaged public func removeFromLessons(_ value: Lesson)

    @objc(addLessons:)
    @NSManaged public func addToLessons(_ values: NSSet)

    @objc(removeLessons:)
    @NSManaged public func removeFromLessons(_ values: NSSet)

}
