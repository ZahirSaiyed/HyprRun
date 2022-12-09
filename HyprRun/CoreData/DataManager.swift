//
//  CoreDataStack.swift
//  HyprRun
//
//  Created by Katie Lin on 11/11/22.
//  References:
// - https://medium.com/@meggsila/core-data-relationship-in-swift-5-made-simple-f51e19b28326
// - https://stackoverflow.com/questions/1077810/delete-reset-all-entries-in-core-data/31961330#31961330
// - https://www.avanderlee.com/swift/constraints-core-data-entities/
// - https://stackoverflow.com/questions/50194151/how-to-set-merge-policy-in-swift-4-coredata
//

import Foundation
import CoreData

class DataManager {
  static let shared = DataManager()
  
  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "HyprRun")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      container.viewContext.mergePolicy = NSMergePolicy(merge: NSMergePolicyType.mergeByPropertyStoreTrumpMergePolicyType)
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
  func run(distance: Double, duration: Int16) -> Run {
    let newRun = Run(context: persistentContainer.viewContext)
    print("I'm in the run function inside of DataManager")
    print(newRun)
    
    newRun.distance = distance
    newRun.duration = duration
    
    return newRun
  }
  
  func location(latitude: Double, longitude: Double, timestamp: Date, currRun: Run) -> Location {
    let locationObj = Location(context: persistentContainer.viewContext)
    
    locationObj.latitude = latitude
    locationObj.longitude = longitude
    locationObj.timestamp = timestamp
    currRun.addToLocations(locationObj)
    
    return locationObj
  }
  
  func fetchRuns() -> [Run] {
    let request: NSFetchRequest<Run> = Run.fetchRequest()
    request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
    var fetchedRuns: [Run] = []
    
    do {
      fetchedRuns = try persistentContainer.viewContext.fetch(request)
    } catch let error {
      print("Error fetching runs: \(error)")
    }
    
    return fetchedRuns
  }
  
  // MARK: - CoreData saving support
  func save() {
    let context = persistentContainer.viewContext
    
    if context.hasChanges {
      do {
        try context.save()
      } catch {
        let nserror = error as NSError
        print("ERROR SAVING DATA: \(nserror), \(nserror.userInfo)")
//        fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
      }
    }
  }
  
  // MARK: - Hard reset
  func reset() {
    let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Run.fetchRequest()
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
    
    do {
      try persistentContainer.viewContext.execute(deleteRequest)
    } catch {
      print(error.localizedDescription)
    }
  }
}
