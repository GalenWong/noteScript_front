//
//  Note+CoreDataProperties.swift
//  
//
//  Created by galenw on 31/3/2018.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Note {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Note> {
        return NSFetchRequest<Note>(entityName: "Note")
    }

    @NSManaged public var dateCreated: Date?
    @NSManaged public var lectureName: String?
    @NSManaged public var noteText: String?
    @NSManaged public var topics: String?

}
