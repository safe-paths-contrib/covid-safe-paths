package org.pathcheck.covidsafepaths.storage

import android.util.Log
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReadableArray
import com.facebook.react.bridge.WritableNativeArray
import com.marianhello.bgloc.data.BackgroundLocation
import io.realm.Realm
import io.realm.RealmConfiguration
import io.realm.Sort.ASCENDING
import io.realm.Sort.DESCENDING
import io.realm.kotlin.where
import org.pathcheck.covidsafepaths.util.getCutoffTimestamp
import java.lang.Exception

object RealmWrapper {
  private const val TAG = "RealmWrapper"
  private const val minimumTimeInterval = 60000 * 5
  private const val daysToKeep = 14

  init {
    val realmConfig = RealmConfiguration.Builder()
        .name("safepaths.realm")
        .addModule(SafePathsRealmModule())
        .build()

    Realm.setDefaultConfiguration(realmConfig)
  }

  fun saveDeviceLocation(backgroundLocation: BackgroundLocation) {
    val realm = Realm.getDefaultInstance()

    realm.executeTransactionAsync({
      val realmResult = it.where<Location>().sort(Location.KEY_TIME, DESCENDING).limit(1).findAll()
      val previousTime = realmResult.getOrNull(0)?.time ?: 0
      if (backgroundLocation.time - previousTime > minimumTimeInterval) {
        Log.d(TAG, "Inserting New Location")
        it.insert(Location.fromBackgroundLocation(backgroundLocation))
      } else {
        Log.d(TAG, "Ignoring save. Minimum time threshold not exceeded")
      }
    }, { realm.close() }, { realm.close() })
  }

  fun importGoogleLocations(locations: ReadableArray) {
    val realm = Realm.getDefaultInstance()

    val locationsToInsert = mutableListOf<Location>()
    realm.executeTransactionAsync({ bgRealm ->
      for (i in 0 until locations.size()) {
        try {
          val map = locations.getMap(i)
          Location.fromGoogleLocation(map)
              ?.let {
                locationsToInsert.add(it)
              }
        } catch (exception: Exception) {
          // possible react type-safe issues here
        }
      }
      bgRealm.insert(locationsToInsert)
    }, { realm.close() }, { realm.close() })
  }

  fun trimLocations() {
    Thread(Runnable {
      val realm = Realm.getDefaultInstance()

      realm.where<Location>()
          .lessThan(Location.KEY_TIME, getCutoffTimestamp(daysToKeep))
          .findAll()
          .deleteAllFromRealm()

      realm.close()
    }).start()
  }

  fun getLocations(promise: Promise) {
    Thread(Runnable {
      val realm = Realm.getDefaultInstance()

      val deviceResults = realm.where<Location>()
          .greaterThanOrEqualTo(Location.KEY_TIME, getCutoffTimestamp(daysToKeep))
          .sort(Location.KEY_TIME, ASCENDING)
          .findAll()

      val writeableArray = WritableNativeArray()
      deviceResults.map {
        writeableArray.pushMap(it.toWritableMap())
      }
      promise.resolve(writeableArray)

      realm.close()
    }).start()
  }
}