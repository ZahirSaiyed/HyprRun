//
//  Run+CoreDataClass.swift
//  HyprRun
//
//  Created by Katie Lin on 12/8/22.
//  References:
//  - https://www.avanderlee.com/swift/nsmanagedobject-awakefrominsert-preparefordeletion/
//

import Foundation
import CoreData


public final class Run: NSManagedObject {
  @NSManaged public var distance: Double
  @NSManaged public var duration: Int16
  @NSManaged public var timestamp: Date?
  @NSManaged public var id: String
  @NSManaged public var locations: NSOrderedSet?
}
