//
//  UnitExtensions.swift
//  HyprRun
//
//  Created by Katie Lin on 11/11/22.
//  Reference: https://www.kodeco.com/553-how-to-make-an-app-like-runkeeper-part-1
//

import Foundation

class UnitConverterPace: UnitConverter {
  private let coeff: Double
  
  init(coefficient:Double) {
    self.coeff = coefficient
  }
  
  override func baseUnitValue(fromValue value: Double) -> Double {
    return reciprocal(value * coeff)
  }
  
  override func value(fromBaseUnitValue baseUnitValue: Double) -> Double {
    return reciprocal(baseUnitValue * coeff)
  }
  
  private func reciprocal(_ value: Double) -> Double {
    guard value != 0 else { return 0}
    return 1.0 / value
  }
}

extension UnitSpeed {
  class var secondsPerMeter: UnitSpeed {
    return UnitSpeed(symbol: "sec/mi", converter: UnitConverterPace(coefficient: 1))
  }
  
  class var minutesPerKilometer: UnitSpeed {
    return UnitSpeed(symbol: "min/km", converter: UnitConverterPace(coefficient: 60.0 / 1000.0))
  }
  
  class var minutesPerMile: UnitSpeed {
    return UnitSpeed(symbol: "min/mi", converter: UnitConverterPace(coefficient: 60.0 / 1609.34))
  }
}

