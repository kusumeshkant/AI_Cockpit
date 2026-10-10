import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Release signing: the upload key comes from android/key.properties
// (git-ignored; template in key.properties.example). Prod release tasks fail
// without it (see the check at the end of this file); dev release builds fall
// back to the debug key. Values are never logged.
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties().apply {
    if (keystorePropertiesFile.exists()) {
        FileInputStream(keystorePropertiesFile).use { load(it) }
    }
}
val signingKeyNames = listOf("storeFile", "storePassword", "keyAlias", "keyPassword")
val missingSigningKeys = signingKeyNames.filter { keystoreProperties.getProperty(it).isNullOrBlank() }
val releaseStoreFile = keystoreProperties.getProperty("storeFile")?.takeIf { it.isNotBlank() }?.let { file(it) }
val hasReleaseSigning = keystorePropertiesFile.exists() &&
    missingSigningKeys.isEmpty() &&
    releaseStoreFile?.exists() == true

android {
    namespace = "app.cockpit.cockpit"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // Required by flutter_local_notifications.
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    flavorDimensions += "env"
    productFlavors {
        create("dev") {
            dimension = "env"
            applicationIdSuffix = ".dev"
            resValue("string", "app_name", "AI Cockpit Dev")
        }
        create("prod") {
            dimension = "env"
            resValue("string", "app_name", "AI Cockpit")
        }
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "app.cockpit.cockpit"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (hasReleaseSigning) {
            create("release") {
                storeFile = releaseStoreFile
                storePassword = keystoreProperties.getProperty("storePassword")
                keyAlias = keystoreProperties.getProperty("keyAlias")
                keyPassword = keystoreProperties.getProperty("keyPassword")
            }
        }
    }

    buildTypes {
        release {
            // Upload key when configured. Without it only dev release builds
            // work (debug key); prod release tasks are stopped below.
            signingConfig = signingConfigs.getByName(if (hasReleaseSigning) "release" else "debug")
        }
    }
}

flutter {
    source = "../.."
}

// Push (FCM) is optional. The google-services plugin fails the build without
// a config file, so it's applied only when one is present: either
// app/google-services.json (one Firebase project listing both
// app.cockpit.cockpit and app.cockpit.cockpit.dev) or per flavor under
// src/dev/ and src/prod/. Without it the app builds and runs with push off.
val googleServicesConfigs = listOf(
    "google-services.json",
    "src/dev/google-services.json",
    "src/prod/google-services.json",
)
if (googleServicesConfigs.any { file(it).exists() }) {
    apply(plugin = "com.google.gms.google-services")
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}

// Prod release builds must be signed with the upload key, never the debug
// key. Checked when the task graph is known, so debug/profile builds and dev
// releases are unaffected. Messages name files and keys only, never values.
val prodReleaseTasks = setOf("bundleProdRelease", "assembleProdRelease")
gradle.taskGraph.whenReady {
    if (allTasks.none { it.project == project && it.name in prodReleaseTasks }) return@whenReady

    val signingProblem = when {
        !keystorePropertiesFile.exists() ->
            "android/key.properties not found. Copy android/key.properties.example and fill it in."
        missingSigningKeys.isNotEmpty() ->
            "android/key.properties is missing values for: ${missingSigningKeys.joinToString()}."
        releaseStoreFile?.exists() != true ->
            "The keystore named by storeFile in android/key.properties does not exist."
        else -> null
    }
    if (signingProblem != null) {
        throw GradleException("Prod release signing is not configured. $signingProblem")
    }
}
