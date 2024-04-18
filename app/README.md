# echoes

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Installations

**Configure credentials**
To run the Maps Flutter Plugin you will need to configure the Mapbox Access Tokens. Read more about access tokens and public/secret scopes at the platform Android or iOS docs.

Secret token
To access platform SDKs you will need to create a secret access token with the Downloads:Read scope and then:

- to download the Android SDK add the token configuration to ~/.gradle/gradle.properties :

```
SDK_REGISTRY_TOKEN=YOUR_SECRET_MAPBOX_ACCESS_TOKEN
```

- to download the iOS SDK add the token configuration to ~/.netrc :

```
machine api.mapbox.com
login mapbox
password YOUR_SECRET_MAPBOX_ACCESS_TOKEN
```

in order to test it easily, you can add this secret token for YOUR_SECRET_MAPBOX_ACCESS_TOKEN
```
sk.eyJ1IjoiYmF6emlsZSIsImEiOiJjbGxmODNuam4weGhuM3FxaG9uczhnanl4In0.3-xPJBVuJgPS3GKX9Afqow
```

Run the project
To run the project you will need to have the Flutter SDK installed. Then you can run the project with the following command:

```
flutter run --dart-define-from-file=config.json
```