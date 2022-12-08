//
//  CoreDataStack.swift
//  HyprRun
//
//  Created by Katie Lin on 11/11/22.
//  Reference: https://medium.com/@meggsila/core-data-relationship-in-swift-5-made-simple-f51e19b28326
//

import Foundation
import CoreData

class DataManager {
  static let shared = DataManager()
  
  lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "HyprRun")
    container.loadPersistentStores(completionHandler: { (storeDescription, error) in
      if let error = error as NSError? {
        fatalError("Unresolved error \(error), \(error.userInfo)")
      }
    })
    return container
  }()
  
  func run(distance: Double, duration: Int16, timestamp: Date) -> Run{
    let newRun = Run(context: persistentContainer.viewContext)
    
    newRun.distance = distance
    newRun.duration = duration
    newRun.timestamp = timestamp
    
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
    let runFetchRequest: NSFetchRequest<NSFetchRequestResult> = Run.fetchRequest()
    let locationFetchRequest: NSFetchRequest<NSFetchRequestResult> = Location.fetchRequest()
    let runDeleteRequest = NSBatchDeleteRequest(fetchRequest: runFetchRequest)
    let locationDeleteRequest = NSBatchDeleteRequest(fetchRequest: locationFetchRequest)
    
    do {
      try persistentContainer.viewContext.execute(runDeleteRequest)
      try persistentContainer.viewContext.execute(locationDeleteRequest)
    } catch {
      print(error.localizedDescription)
    }
  }
}
