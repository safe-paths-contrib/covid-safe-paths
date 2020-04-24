//
//  Location.swift
//  COVIDSafePaths
//
//  Created by Tyler Roach on 4/23/20.
//  Copyright © 2020 Path Check Inc. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers
class Location: Object {
  dynamic var time: Date = Date.init()
  dynamic var latitude: Double = 0
  dynamic var longitude: Double = 0
  dynamic var provider: String?
  let altitude = RealmOptional<Double>()
  let speed = RealmOptional<Float>()
  let accuracy = RealmOptional<Float>()
  let altitudeAccuracy = RealmOptional<Float>()
  let bearing = RealmOptional<Float>()
  
  static func fromBackgroundLocation(backgroundLocation: MAURLocation) -> Location {
    let location = Location()
    location.time = backgroundLocation.time
    location.latitude = backgroundLocation.latitude.doubleValue
    location.longitude = backgroundLocation.longitude.doubleValue
    location.altitude.value = backgroundLocation.altitude.doubleValue
    location.speed.value = backgroundLocation.speed.floatValue
    location.accuracy.value = backgroundLocation.accuracy.floatValue
    location.altitudeAccuracy.value = backgroundLocation.altitudeAccuracy.floatValue
    location.bearing.value = backgroundLocation.heading.floatValue
    return location;
  }
}
