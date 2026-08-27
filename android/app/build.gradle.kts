plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.carlos_germano.controle_simples_gastos"
    compileSdk = flutter.compileSdkVersion.toInt()
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.carlos_germano.controle_simples_gastos"
        // ✅ CORREÇÃO: Defina valores mínimos explícitos para o SQLite
        minSdk = flutter.minSdkVersion // ou flutter.minSdkVersion.toInt() se for maior
        targetSdk = 33 // ou flutter.targetSdkVersion.toInt() 
        versionCode = 1
        versionName = "1.0.0"
        multiDexEnabled = true
    }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = false // ✅ Mude para false para debugging
            isShrinkResources = false // ✅ Mude para false para debugging
        }
        getByName("debug") {
            isMinifyEnabled = false
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")
    implementation("androidx.multidex:multidex:2.0.1")
}
