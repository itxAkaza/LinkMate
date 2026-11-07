
import java.io.FileInputStream
import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    // Flutter Gradle plugin must be applied after Android and Kotlin.
    id("dev.flutter.flutter-gradle-plugin")
}

// Load the upload keystore configuration.
val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")

if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
}

android {
    // Keep the existing namespace; it can differ from applicationId.
    namespace = "com.pixelplot.linkvault.linkvault"

    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // Required by flutter_local_notifications.
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // Permanent package ID for LinkMate.
        applicationId = "com.pixelplot.linkmate"

        // Keep Flutter's default minimum supported Android version.
        minSdk = flutter.minSdkVersion

        // Google Play requirement as of August 31, 2026.
        targetSdk = 36

        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {

        create("release") {
            keyAlias = keystoreProperties.getProperty("keyAlias")
            keyPassword = keystoreProperties.getProperty("keyPassword")
            storeFile = keystoreProperties
                .getProperty("storeFile")
                ?.let { file(it) }
            storePassword = keystoreProperties.getProperty("storePassword")
        }
    }

    buildTypes {
        getByName("debug") {
            applicationIdSuffix = ".debug"
        }

        release {
            // Use your private upload key, not the debug key.
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

dependencies {
    // Required by flutter_local_notifications.
    coreLibraryDesugaring(
        "com.android.tools:desugar_jdk_libs:2.1.5"
    )
}

flutter {
    source = "../.."
}
