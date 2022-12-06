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
