//
//  RealmWrapper.swift
//  COVIDSafePaths
//
//  Created by Tyler Roach on 4/23/20.
//  Copyright © 2020 Path Check Inc. All rights reserved.
//

import Foundation
import RealmSwift

class RealmWrapper: NSObject {
  
  @objc static let shared = RealmWrapper()
  
  private static let MINIMUM_TIME_INTERVAL = 60 * 4
  private static let DAYS_TO_KEEP = 14
  private static let KEY_LAST_SAVED_TIME = "lastSavedTime"
  
  let realmConfig: Realm.Configuration
  
  private override init() {
    realmConfig = Realm.Configuration(objectTypes: [Location.self])
    Realm.Configuration.defaultConfiguration = realmConfig
  }
  
  @objc func saveDeviceLocation(backgroundLocation: MAURLocation) {
    // The geolocation library sometimes returns nil times.
    // Almost immediately after these locations, we receive an identical location containing a time.
    guard backgroundLocation.time != nil else {
      return
    }
    
    // Check to only insert location if > minimum time interval
    // Using UserDefaults here since realm reads are async and we could end up saving multiple locations before a query for the most recent record returns
    let currentTime = Int(Date().timeIntervalSince1970)
    let lastSavedTime = UserDefaults.standard.integer(forKey: RealmWrapper.KEY_LAST_SAVED_TIME)
    if (currentTime - lastSavedTime < RealmWrapper.MINIMUM_TIME_INTERVAL) {
      return
    } else {
      UserDefaults.standard.set(currentTime, forKey: RealmWrapper.KEY_LAST_SAVED_TIME)
    }
    
    DispatchQueue(label: "realm").async {
      autoreleasepool { [weak self] in
        guard let `self` = self else { return }
        let realm = try! Realm(configuration: self.realmConfig)
        let location = Location.fromBackgroundLocation(backgroundLocation: backgroundLocation)
        try! realm.write {
          realm.add(location, update: .modified)
        }
      }
    }
  }
  
  func importLocations(locations: NSArray, source: Int, resolve: @escaping RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
    DispatchQueue(label: "realm").async {
      autoreleasepool { [weak self] in
        guard let `self` = self else { return }
        let realm = try! Realm(configuration: self.realmConfig)
        let locationsToInsert = locations.compactMap {
          Location.fromImportLocation(dictionary: $0 as? NSDictionary, source: source)
        }
        try! realm.write {
          realm.add(locationsToInsert, update: .modified)
        }
        resolve(true)
      }
    }
  }
  
  @objc func trimLocations() {
    DispatchQueue(label: "realm").async {
      autoreleasepool { [weak self] in
        guard let `self` = self else { return }
        let realm = try! Realm(configuration: self.realmConfig)
        let realmResults = realm.objects(Location.self)
          .filter("\(Location.KEY_TIME)<\(self.getCutoffTime())")
        try! realm.write {
          realm.delete(realmResults)
        }
      }
    }
  }
  
  func getLocations(resolve: @escaping RCTPromiseResolveBlock, reject: RCTPromiseRejectBlock) {
    DispatchQueue(label: "realm").async {
      autoreleasepool { [weak self] in
        guard let `self` = self else { return }
        let realm = try! Realm(configuration: self.realmConfig)
        let realmResults = realm.objects(Location.self)
          .filter("\(Location.KEY_TIME)>=\(self.getCutoffTime())")
          .sorted(byKeyPath: Location.KEY_TIME, ascending: true)
        let shortenedLocations = Array(realmResults.map { $0.toSharableDictionary() })
        resolve(shortenedLocations)
      }
    }
  }
  
  func getCutoffTime() -> Int {
    return Int(Date().timeIntervalSince1970) - (RealmWrapper.DAYS_TO_KEEP * 86400)
  }
}
