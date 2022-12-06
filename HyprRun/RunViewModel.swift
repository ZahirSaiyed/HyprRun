//
//  ViewModel.swift
//  HyprRun
//
//  Created by Katie Lin on 11/14/22.
//  References:
//    - https://www.kodeco.com/553-how-to-make-an-app-like-runkeeper-part-1
//    - https://medium.com/@ytyubox/inheriting-existing-class-type-to-support-observableobject-9a6685dd0d30
//    - https://stevenpcurtis.medium.com/why-do-we-ever-need-to-inherit-from-nsobject-b4ec111a58c7
//    - https://stackoverflow.com/questions/29406256/how-can-i-pause-and-resume-nstimer-scheduledtimerwithtimeinterval-in-swift
//

import Foundation
import CoreLocation
import CoreData
import UIKit

class RunViewModel: NSObject {
  let locationManager = LocationManager.shared
  
//  var run: Run?
  var seconds = 0
  var timer: Timer?

// TODO: Add pace to CoreData model, add pace updating logic to functions (similar to 'startLocationUpdates()'; add vibe to CoreData model
//  var pace = Measurement(value: 0, unit: UnitSpeed.minutesPerMile)
  var distance = Measurement(value: 0, unit: UnitLength.meters)
  var locationList: [CLLocation] = []
  
  enum RunState {
    case notRunning
    case running
    case paused
  }
  
  override init() {
    locationManager.requestWhenInUseAuthorization()
  }
  
  func startLocationUpdates() {
    locationManager.delegate = self
    locationManager.activityType = .fitness
    locationManager.distanceFilter = 10
    locationManager.startUpdatingLocation()
  }
}

extension RunViewModel: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    for newLocation in locations {
      let howRecent = newLocation.timestamp.timeIntervalSinceNow
      guard newLocation.horizontalAccuracy < 20 && abs(howRecent) < 10 else {
        continue
      }
      
      if let lastLocation = locationList.last {
        let delta = newLocation.distance(from: lastLocation)
        distance = distance + Measurement(value: delta, unit: UnitLength.meters)
      }
      
      locationList.append(newLocation)
    }
  }
}

class UIRunViewModel: RunViewModel, ObservableObject {
  @Published var currentState: RunState
//  @Published var runs = [Run]
  
  override init() {
    self.currentState = .notRunning
    super.init()
  }
  
  @Published var secondsLeft = 4
  @Published var distanceLabel: String = ""
  @Published var timeLabel: String = ""
  @Published var paceLabel: String = ""
  
  func eachSecond() {
    seconds += 1
    updateDisplay()
  }
  
  func updateDisplay() {
    let formattedDistance = FormatDisplay.distance(distance)
    let formattedTime = FormatDisplay.time(seconds)
    let formattedPace = FormatDisplay.pace(distance: distance, seconds: seconds, outputUnit: UnitSpeed.minutesPerMile)
    
    distanceLabel = "\(formattedDistance)"
    timeLabel = "\(formattedTime)"
    paceLabel = "\(formattedPace)"
  }
  
  func startRun() {
    secondsLeft = 4
    seconds = 0
    distance = Measurement(value: 0, unit: UnitLength.meters)
    // add pace here too!
    updateDisplay()
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
      self.eachSecond()
    }
		self.eachSecond()
    self.currentState = .running
    startLocationUpdates()
  }
  
  func pauseRun() {
    timer?.invalidate()
    self.currentState = .paused
  }
  
  func resumeRun() {
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
      self.eachSecond()
    }
    self.currentState = .running
  }
  
  func endRun() {
    timer?.invalidate()
    self.currentState = .notRunning
    locationManager.stopUpdatingLocation()
    self.saveRun()
  }
  
  func saveRun() {
//    let entity = NSEntityDescription.entity(forEntityName: "Run", in: CoreDataStack.context)
//    let newRun = NSManagedObject(entity: entity!, insertInto: CoreDataStack.context)
//    newRun.setValue(distance.value, forKey: "distance")
//    newRun.setValue(Int16(seconds), forKey: "duration")
//    newRun.setValue(Date(), forKey: "timestamp")
//    newRun.pace = pace.value
    
//    for location in locationList {
//      let locationObject = Location(context: CoreDataStack.context)
//      locationObject.timestamp = location.timestamp
//      locationObject.latitude = location.coordinate.latitude
//      locationObject.longitude = location.coordinate.longitude
////      newRun.addToLocations(locationObject)
//    }
//
//    CoreDataStack.saveContext()
////    run = newRun
  }
  
  func fetchRuns() {
//    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Run")
//    request.returnsObjectsAsFaults = false
//
//    do {
//      let result = try CoreDataStack.context.fetch(request)
//      for data in result as! [NSManagedObject] {
//        let newRun = Run()
//        newRun.distance = data.value(forKey: "distance") as? Double ?? 0.0
//        newRun.duration = data.value(forKey: "duration") as? Int16 ?? 0
//        newRun.timestamp = data.value(forKey: "timestamp") as? Date
//        runs.append(newRun)
//        NSLog("[Runs] loaded Run with date: \(data.value(forKey: "timestamp") as! Date) from CoreData")
//      }
//    } catch {
//      NSLog("[Runs] ERROR: was unable to load Runs from CoreData")
//    }
  }
}
