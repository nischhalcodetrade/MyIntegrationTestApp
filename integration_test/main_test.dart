import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:integration_test_example_app/src/controller/db/db.dart';

import 'src/screens/auth/sign_in/sign_in_test.dart';
import 'src/screens/auth/sign_up/sign_up_test.dart';
import 'src/screens/home/home_test.dart';

void main() async {
  try {
    await initializeTest();
    FlutterError.onError = (details) {
      log(details.exception.toString());
    };
  } catch (ex) {
    log(ex.toString());
  }
}

Future<void> initializeTest() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await DB.instance().initialize();

  group('Sign Up Test Group',skip: false, () {
    signUpTest1();
    signUpTest2();
    signUpTest3();
    signUpTest4();
  });

  group('Sign In Test Group', () {
    signInTest1();
    signInTest2();
    signInTest3();
    signInTest4();
  });

  group('Home Test Group', () {
    homeTest1();
    homeTest2();
    homeTest3();
  });
}
