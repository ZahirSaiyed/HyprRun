//
//  UIRunViewModel.swift
//  HyprRun
//
//  Created by Katie Lin on 12/6/22.
//

import Foundation
import CoreLocation
import CoreData
import UIKit

class UIRunViewModel: RunViewModel, ObservableObject {
  @Published var currentState: RunState
  @Published var runs = [Run]()
  
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
    let newRun = DataManager.shared.run(distance: distance.value, duration: Int16(seconds), timestamp: Date())
    
    for loc in locationList {
      _ = DataManager.shared.location(latitude: loc.coordinate.latitude, longitude: loc.coordinate.longitude, timestamp: loc.timestamp, currRun: newRun)
    }
    
    DataManager.shared.save()
  }
  
  func retrieveRuns() {
    runs = DataManager.shared.fetchRuns()
  }
  
  func resetData() {
    DataManager.shared.reset()
    retrieveRuns()
  }
}
