package org.pathcheck.covidsafepaths.storage

import com.marianhello.bgloc.data.BackgroundLocation
import io.realm.Realm
import io.realm.RealmConfiguration

object RealmWrapper {

  private val realm: Realm

  init {
    val realmConfig = RealmConfiguration.Builder()
        .name("safepaths.realm")
        .addModule(SafePathsRealmModule())
        .build()

    realm = Realm.getInstance(realmConfig)
  }

  fun saveLocation(backgroundLocation: BackgroundLocation) {
    realm.executeTransaction {
      it.insert(Location.fromBackgroundLocation(backgroundLocation))
    }
  }

  fun close() {
    realm.close()
  }
}