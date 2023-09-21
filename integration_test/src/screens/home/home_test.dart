import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test_example_app/src/controller/bloc/home/home_bloc.dart';
import 'package:integration_test_example_app/src/controller/bloc/home/home_state.dart';
import 'package:integration_test_example_app/src/controller/bloc/sign_in/sign_in_bloc.dart';
import 'package:integration_test_example_app/src/controller/bloc/sign_in/sign_in_state.dart';

import '../../utils/testing_helper.dart';

void homeTest1() {
  testWidgets("Home Screen Data", (WidgetTester tester) async {
    TestHelper.tester = tester;
    await TestHelper.pumpApp();
    await TestHelper.enterDataInTextField(
        data: 'codetrade.io', name: 'Username');
    await TestHelper.enterDataInTextField(data: 'password', name: 'Password');
    await TestHelper.tapButton(finder: find.bySubtype<Checkbox>());
    await TestHelper.tapButton(name: 'Sign in');
    expect(find.text('codetrade.io'), findsOneWidget);
    expect(find.text('Codetrade'), findsOneWidget);
    expect(find.text('Io'), findsOneWidget);
    expect(find.text('Gender.male'), findsOneWidget);
    expect(find.text('password'), findsOneWidget);
  });
}

void homeTest2() {
  testWidgets("ALready Signed In", (WidgetTester tester) async {
    TestHelper.tester = tester;
    await TestHelper.pumpApp();
    expect(find.text('Hi Codetrade Io'), findsOneWidget);
  });
}

void homeTest3() {
  testWidgets("Delete User Test", (WidgetTester tester) async {
    TestHelper.tester = tester;
    await TestHelper.pumpApp();
    HomeBloc homeBloc = TestHelper.getBloc<HomeBloc>();
    await TestHelper.tapButton(name: 'Delete User');
    expect(homeBloc.state.runtimeType, SignOutSuccess);
    SignInBloc signInBloc = TestHelper.getBloc<SignInBloc>();
    await TestHelper.tapButton(name: 'Sign in');
    expect(signInBloc.state.runtimeType, SignInFailed);
    expect(find.widgetWithText(SnackBar, 'Sign In Failed: User not found'),
        findsOneWidget);
  });
}
