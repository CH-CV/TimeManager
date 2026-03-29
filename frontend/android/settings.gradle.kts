pluginManagement {
    val flutterSdkPath =
        run {
            val properties = java.util.Properties()
            file("local.properties").inputStream().use { properties.load(it) }
            val flutterSdkPath = properties.getProperty("flutter.sdk")
            require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
            flutterSdkPath
        }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        // download.flutter.io 镜像（Flutter Android 产物）
        maven { url = uri("https://mirrors.tuna.tsinghua.edu.cn/flutter/download.flutter.io") }
        maven { url = uri("https://mirrors.cloud.tencent.com/flutter/download.flutter.io") }
        // 阿里云
        maven { url = uri("https://maven.aliyun.com/repository/google") }
        maven { url = uri("https://maven.aliyun.com/repository/public") }
        maven { url = uri("https://maven.aliyun.com/repository/gradle-plugin") }
        // 腾讯云
        maven { url = uri("https://mirrors.cloud.tencent.com/repository/maven/google") }
        maven { url = uri("https://mirrors.cloud.tencent.com/repository/maven/public") }
        maven { url = uri("https://mirrors.cloud.tencent.com/repository/maven/gradle-plugin") }
        // 华为云
        maven { url = uri("https://repo.huaweicloud.com/repository/maven/google") }
        maven { url = uri("https://repo.huaweicloud.com/repository/maven/public") }
        maven { url = uri("https://repo.huaweicloud.com/repository/maven/gradle-plugin") }
        // 南京大学
        maven { url = uri("https://maven.nju.edu.cn/repository/google") }
        maven { url = uri("https://maven.nju.edu.cn/repository/public") }
        maven { url = uri("https://maven.nju.edu.cn/repository/gradle-plugin") }
        // 中科大
        maven { url = uri("https://mirrors.ustc.edu.cn/repository/google") }
        maven { url = uri("https://mirrors.ustc.edu.cn/repository/public") }
        maven { url = uri("https://mirrors.ustc.edu.cn/repository/gradle-plugin") }
        // 清华大学
        maven { url = uri("https://mirrors.tuna.tsinghua.edu.cn/repository/google") }
        maven { url = uri("https://mirrors.tuna.tsinghua.edu.cn/repository/public") }
        maven { url = uri("https://mirrors.tuna.tsinghua.edu.cn/repository/gradle-plugin") }
        // 官方源（备用）
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.11.1" apply false
    id("org.jetbrains.kotlin.android") version "2.2.20" apply false
}

include(":app")
