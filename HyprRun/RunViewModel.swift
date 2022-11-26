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
import UIKit

class RunViewModel: NSObject {
  let locationManager = LocationManager.shared
  
  var run: Run?
  var seconds = 0
  var timer: Timer?

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
//    self.viewRouter.setRoute(.postRunView)
    timer?.invalidate()
    self.currentState = .notRunning
    locationManager.stopUpdatingLocation()
    self.saveRun()
  }
  
  func saveRun() {
    let newRun = Run(context: CoreDataStack.context)
    newRun.distance = distance.value
    newRun.duration = Int16(seconds)
    newRun.timestamp = Date()
    
    for location in locationList {
      let locationObject = Location(context: CoreDataStack.context)
      locationObject.timestamp = location.timestamp
      locationObject.latitude = location.coordinate.latitude
      locationObject.longitude = location.coordinate.longitude
      newRun.addToLocations(locationObject)
    }
  }
}
