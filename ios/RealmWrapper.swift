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
  
  private static let minimumTimeInterval = 60 * 4
  private static let daysToKeep = 14

  let realmConfig: Realm.Configuration
  
  private override init() {
    realmConfig = Realm.Configuration(objectTypes: [Location.self])
    Realm.Configuration.defaultConfiguration = realmConfig
  }
  
  @objc func saveDeviceLocation(backgroundLocation: MAURLocation) {
    DispatchQueue(label: "realm").async {
        autoreleasepool { [weak self] in
          guard let `self` = self else { return }

          let realm = try! Realm(configuration: self.realmConfig)
          
          let realmResults = realm.objects(Location.self)
            .filter("\(Location.KEY_SOURCE)=\(Location.SOURCE_DEVICE)")
            .sorted(byKeyPath: Location.KEY_TIME, ascending: false)
          
          let currentTime = Int(Date().timeIntervalSince1970)
          let previousTime = realmResults.first?.time ?? 0
          print ("\(currentTime)and \(previousTime)")
          if (currentTime - previousTime > RealmWrapper.minimumTimeInterval) {
            let location = Location.fromBackgroundLocation(backgroundLocation: backgroundLocation)
            try! realm.write {
              realm.add(location, update: .modified)
            }
            print("Inserting New Location")
          } else {
            print("Ignoring save. Minimum time threshold not exceeded")
          }
        }
    }
  }
  
  func trimLocations() {
    DispatchQueue(label: "realm").async {
        autoreleasepool { [weak self] in
          guard let `self` = self else { return }

          let realm = try! Realm(configuration: self.realmConfig)
          
          let realmResults = realm.objects(Location.self)
            .filter("\(Location.KEY_TIME)<\(self.getCutoffTime())")
          
          realm.delete(realmResults)
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
    return Int(Date().timeIntervalSince1970) - (RealmWrapper.daysToKeep * 86400)
  }
}
