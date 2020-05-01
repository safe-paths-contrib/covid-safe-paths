<div align="center">
  <h1>COVID Safe Paths</h1>

  <a href="https://covidsafepaths.org">
    <img
      height="80"
      width="80"
      alt="safe paths logo"
      src="./assets/Safe_Paths_Logo.png"
    />
  </a>

  <p>
    Applying the technology and philosophy of Private Kit to COVID-19
  </p>
  
  <b>**https://covidsafepaths.org | https://safepaths.mit.edu**</b>
</div>

<hr />

Help us stop COVID-19.

We’re building the next generation of secure location logging to preserve privacy and _#flattenthecurve_

Location logs provide time-stamped records of where users have been, allowing them to share information with health officials accurately and quickly. This helps support contact tracing efforts to slow the spread of the virus.

What’s truly special about Safe Paths, though, is its privacy protection.

Data never leaves a user's device without their password entry and explicit consent. The location log generated by Safe Paths cannot be accessed from outside the user’s device, meaning data transfer occurs only if the user chooses to share it with a researcher or health official.

<img align="right" src="./assets/PreviewUI.png" data-canonical-src="./assets/PreviewUI.png"/>

## Overview

Safe Paths is a ‘privacy-first’ app that allows you to log your GPS trails on your own phone. The information is stored locally and never shared with anyone (not even with us or MIT) until you explicitly decide to manually export the data.

The location log generated by Safe Paths cannot be accessed from outside the user’s device. However, the user can import and export their location information and use it in other projects and applications.

Safe Paths logs your device’s location once every five minutes and stores 14 days of data.

### Private Kit WhitePaper

[Apps Gone Rogue: Maintaining Personal Privacy in an Epidemic](https://drive.google.com/file/d/1nwOR4drE3YdkCkyy_HBd6giQPPhLEkRc/view?usp=sharing)

### Downloads for COVID Safe Paths

_coming soon!_

### Downloads for Private Kit (technology beta)

[Google Play](https://play.google.com/store/apps/details?id=edu.mit.privatekit) | [Apple Store](https://apps.apple.com/us/app/private-kit-prototype/id1501903733)

<br />

# Development Overview

![Android and iOS build on MacOS](https://github.com/tripleblindmarket/covid-safe-paths/workflows/Android%20and%20iOS%20build%20on%20MacOS/badge.svg)

_Safe Paths_ is a built on [React Native](https://reactnative.dev/docs/getting-started) v0.61.5

## Contributing

Read the [contribution guidelines](CONTRIBUTING.md).

## Architecture

View the [architecture diagram](docs/Private_Kit_Diagram.png) for a basic overview on the sequencing of generalized events and services that are used by Safe Paths.

## Developer Setup

First, run the appropriate setup script for your system. This will install relevant packages, walk through Android Studio configuration, etc.

**Note:** You will still need to [configure an Android Virtual Device (AVD)](https://developer.android.com/studio/run/managing-avds#createavd) after running the script.

#### Linux/MacOS

```
dev_setup.sh
```

#### Windows

```
dev_setup.bat
```

## Running

**Note:** In some cases, these procedures can lead to the error `Failed to load bundle - Could not connect to development server`. In these cases, kill all other react-native processes and try it again.

#### Android (Windows, Linux, macOS)

```
npx react-native run-android
```

Device storage can be cleared by long-pressing on the app icon in the simulator, clicking "App info", then "Storage", and lastly, "Clear Storage".

#### iOS (macOS only)

```
yarn install:pod ## only needs to be ran once
npx react-native run-ios
```

Device storage can be cleared by clicking "Hardware" on the system toolbar, and then "Erase all content and settings".

### Release Builds

Generating a release build is an optional step in the development process.

- [Android instructions](https://reactnative.dev/docs/signed-apk-android)

### Debugging

[react-native-debugger](https://github.com/jhen0409/react-native-debugger) is recommended. This tool will provide visibility of the JSX hierarchy, breakpoint usage, monitoring of network calls, and other common debugging tasks.

## Testing

Tests are ran automatically through Github actions - PRs are not able to be merged if there are tests that are failing.

### Unit Test

To run the unit tests:

```
yarn test --watch
```

[Snapshot testing](https://jestjs.io/docs/en/snapshot-testing) is used as a quick way to verify that the UI has not changed. To update the snapshots:

```
yarn update-snapshots
```

### e2e Test

**Note:** Right now, there is only e2e test support for iOS.

e2e tests are written using [_detox_](https://github.com/wix/Detox). Screenshots of each test run are saved to `e2e/artifacts` for review.

To run the e2e tests:

```
yarn detox-setup ## only needs to be run once
yarn build:e2e:ios ## needs to be run after any code change
yarn test:e2e:iphone{11, -se, 8}
```

### Manual Device Testing

Mobile devices come in many different shapes and sizes - it is important to test your code on a variety of simulators to ensure it looks correct on all device types.

Before pushing up code, it is recommended to manually test your code on the following devices:

- Nexus 4 (smaller screen)
- iPhone 8 (smaller screen)
- Pixel 3 XL (larger screen)
- iPhone 11 (screen w/ notch)
