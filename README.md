# Gaymer Streams for iOS and Android

iOS and Android app written in the [Dart programming language](https://www.dartlang.org/) using the [Flutter.io](http://flutter.io/) SDK.


## Building for Android

Building release APK in Flutter requires the following additional changes to the existing documentation:

1. Follow the official instructions [here](https://flutter.io/android-release/#installing-a-release-apk-on-a-device).
2. Update the flutter project and depedencies (plugins) such as firebase_analytics, firebase_database, url_launcher, etc. by following their breaking changes [here](https://github.com/flutter/flutter/wiki/Updating-Flutter-projects-to-Gradle-4.1-and-Android-Studio-Gradle-plugin-3.0.1).
3. If there are still errors like the one below, 
```
Could not resolve project :url_launcher`.
  Required by: 
    project :app
  > Unable to find a matching configuration of project :url_launcher:
```
add the following to your app/build.gradle (source: https://stackoverflow.com/questions/48054291/cant-build-release-apk-for-flutter):
```
 buildTypes {
        release {
            profile {
                matchingFallbacks = ['debug', 'release']
            }
            signingConfig signingConfigs.release
        }
    }
```   