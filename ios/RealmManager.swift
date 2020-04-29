//
//  RealmManager.swift
//  COVIDSafePaths
//
//  Created by Tyler Roach on 4/29/20.
//  Copyright © 2020 Path Check Inc. All rights reserved.
//

import Foundation

@objc(RealmManager)
class RealmManager: NSObject {
  
  @objc
  func getLocations(_ resolve: @escaping RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) -> Void {
    RealmWrapper.shared.getLocations(resolve: resolve, reject: reject)
  }
  
  @objc
  func importGoogleLocations(_ locations: NSDictionary, resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) -> Void {
    
  }
  
  @objc
  func migrateExistingLocations(_ locations: NSDictionary, resolve: RCTPromiseResolveBlock, rejecter reject: RCTPromiseRejectBlock) -> Void {
    
  }

}
