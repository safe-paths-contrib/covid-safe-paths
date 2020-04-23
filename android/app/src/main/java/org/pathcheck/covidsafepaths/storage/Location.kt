package org.pathcheck.covidsafepaths.storage

import com.marianhello.bgloc.data.BackgroundLocation
import io.realm.RealmObject

/*
  Realm requires a no-op constructor. Need to use var and fill will default value
 */
open class Location(
  var time: Long = 0,
  var latitude: Double = 0.0,
  var longitude: Double = 0.0,
  var altitude: Double? = null,
  var speed: Float? = null,
  var accuracy: Float? = null,
  var bearing: Float? = null,
  var provider: String? = null,
  var mockFlags: Int? = null
) : RealmObject() {

  companion object {

    fun fromBackgroundLocation(backgroundLocation: BackgroundLocation): Location {
      return Location(
          time = backgroundLocation.time,
          latitude = backgroundLocation.latitude,
          longitude = backgroundLocation.longitude,
          altitude = if (backgroundLocation.hasAltitude()) backgroundLocation.altitude else null,
          speed = if (backgroundLocation.hasSpeed()) backgroundLocation.speed else null,
          accuracy = if (backgroundLocation.hasAccuracy()) backgroundLocation.accuracy else null,
          bearing = if (backgroundLocation.hasBearing()) backgroundLocation.bearing else null,
          provider = backgroundLocation.provider,
          mockFlags = backgroundLocation.mockFlags
      )
    }
  }
}