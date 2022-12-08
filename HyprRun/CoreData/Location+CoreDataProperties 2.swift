//
//  Location+CoreDataProperties.swift
//  HyprRun
//
//  Created by Katie Lin on 12/6/22.
//
//

import Foundation
import CoreData


extension Location {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Location> {
        return NSFetchRequest<Location>(entityName: "Location")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var timestamp: Date?
    @NSManaged public var run: Run?

}

extension Location : Identifiable {

}
