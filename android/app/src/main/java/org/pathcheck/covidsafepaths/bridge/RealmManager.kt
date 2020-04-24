package org.pathcheck.covidsafepaths.bridge

import android.util.Log
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod

class RealmManager(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {

  override fun getName(): String {
    return "RealmManager"
  }

  @ReactMethod
  fun getLocations() {
    Log.d("RealmManager", "Get Locations called")
  }
}