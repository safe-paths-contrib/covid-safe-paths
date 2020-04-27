package org.pathcheck.covidsafepaths.bridge

import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import org.pathcheck.covidsafepaths.storage.RealmWrapper

class RealmManager(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

  override fun getName(): String {
    return "RealmManager"
  }

  @ReactMethod
  fun getLocations(promise: Promise) {
    RealmWrapper.getLocations(promise)
  }
}