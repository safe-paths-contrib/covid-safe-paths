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

  let realmConfig: Realm.Configuration
  
  private override init() {
    realmConfig = Realm.Configuration(objectTypes: [Location.self])
    
  }
  
  @objc func insertLocation(backgroundLocation: MAURLocation) {
    let realm = try! Realm(configuration: realmConfig)
    let location = Location.fromBackgroundLocation(backgroundLocation: backgroundLocation)
    try! realm.write {
      realm.add(location)
    }
  }
}
