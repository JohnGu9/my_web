import 'package:flutter/material.dart';
import 'flutter_version.dart';

class Constants {
  static const String buildVersion = "0.2.0-nullsafety-alpha";
  static String get frameworkVersion => version['frameworkVersion']!;
  static String get channel => version['channel']!;
  static String get repositoryUrl => version['repositoryUrl']!;
  static String get frameworkRevision => version['frameworkRevision']!;
  static String get frameworkCommitDate => version['frameworkCommitDate']!;
  static String get engineRevision => version['engineRevision']!;
  static String get dartSdkVersion => version['dartSdkVersion']!;

  static const AssetImage personLogoImage =
      AssetImage("assets/images/logo.png");
  static const AssetImage githubLogoImage =
      AssetImage("assets/images/github.png");
  static const AssetImage mailLogoImage =
      AssetImage("assets/images/outlook.png");
  static const AssetImage mediumLogoImage =
      AssetImage("assets/images/medium.png");
  static const AssetImage pwaImage = AssetImage("assets/images/pwa.png");

  static const AssetImage backgroundImage =
      AssetImage("assets/images/background.jpg");
  static const AssetImage skillImage = AssetImage("assets/images/skill.jpg");
  static const AssetImage otherImage = AssetImage("assets/images/other.jpg");
  static const AssetImage zhWitheImage =
      AssetImage("assets/images/zh_white.png");
  static const AssetImage zhBlackImage =
      AssetImage("assets/images/zh_black.png");

  static const AssetImage jinanLogoImage =
      AssetImage("assets/images/jinan.png");

  static const AssetImage myDevelopmentImage =
      AssetImage("assets/images/myDevelopment.jpg");

  static const AssetImage dartLogoImage = AssetImage("assets/images/dart.png");
  static const AssetImage tensorflowLogoImage =
      AssetImage("assets/images/tensorflow.png");
  static const AssetImage cmakeLogoImage =
      AssetImage("assets/images/cmake.png");
  static const AssetImage opencvLogoImage =
      AssetImage("assets/images/opencv.png");
  static const AssetImage pythonLogoImage =
      AssetImage("assets/images/python.png");
  static const AssetImage javaLogoImage = AssetImage("assets/images/java.png");
  static const AssetImage kotlinLogoImage =
      AssetImage("assets/images/kotlin.png");
  static const AssetImage javascriptLogoImage =
      AssetImage("assets/images/javascript.png");
  static const AssetImage cppLogoImage = AssetImage("assets/images/cpp.png");
  static const AssetImage swiftLogoImage =
      AssetImage("assets/images/swift.png");
  static const AssetImage rustLogoImage = AssetImage("assets/images/rust.png");
  static const AssetImage goLogoImage = AssetImage("assets/images/go.png");
  static const AssetImage k8sLogoImage = AssetImage("assets/images/k8s.png");
  static const AssetImage qtLogoImage = AssetImage("assets/images/qt.png");
  static const AssetImage flaskLogoImage =
      AssetImage("assets/images/flask.png");
  static const AssetImage electronLogoImage =
      AssetImage("assets/images/electron.png");
  static const AssetImage nodejsLogoImage =
      AssetImage("assets/images/nodejs.png");
  static const AssetImage typescriptLogoImage =
      AssetImage("assets/images/typescript.png");
}
