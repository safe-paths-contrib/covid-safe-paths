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

  let realm: Realm
  
  private override init() {
    let config = Realm.Configuration(objectTypes: [Location.self])
    realm = try! Realm(configuration: config)
  }
  
  @objc func insertLocation(backgroundLocation: MAURLocation) {
    let location = Location.fromBackgroundLocation(backgroundLocation: backgroundLocation)
    try! realm.write {
      realm.add(location)
    }
  }
}
