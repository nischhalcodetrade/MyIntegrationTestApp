import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test_example_app/src/controller/bloc/sign_in/sign_in_bloc.dart';
import 'package:integration_test_example_app/src/controller/bloc/sign_in/sign_in_state.dart';

import '../../../utils/testing_helper.dart';

void signInTest1() {
  testWidgets("Wrong Username", (WidgetTester tester) async {
    TestHelper.tester = tester;
    await TestHelper.pumpApp();
    SignInBloc signInBloc = TestHelper.getBloc<SignInBloc>();
    await TestHelper.enterDataInTextField(data: 'codetrade', name: 'Username');
    await TestHelper.enterDataInTextField(data: 'password', name: 'Password');
    await TestHelper.tapButton(name: 'Sign in');
    expect(signInBloc.state.runtimeType, SignInFailed);
    expect(find.widgetWithText(SnackBar, 'Sign In Failed: User not found'),
        findsOneWidget);
  });
}

void signInTest2() {
  testWidgets("Wrong Password", (WidgetTester tester) async {
    TestHelper.tester = tester;
    await TestHelper.pumpApp();
    SignInBloc signInBloc = TestHelper.getBloc<SignInBloc>();
    await TestHelper.enterDataInTextField(
        data: 'codetrade.io', name: 'Username');
    await TestHelper.enterDataInTextField(data: 'passwod', name: 'Password');
    await TestHelper.tapButton(name: 'Sign in');
    expect(signInBloc.state.runtimeType, SignInFailed);
    expect(
        find.widgetWithText(
            SnackBar, 'Sign In Failed: Please enter the correct password'),
        findsOneWidget);
  });
}

void signInTest3() {
  testWidgets("Sign In with Remember Me", (WidgetTester tester) async {
    TestHelper.tester = tester;
    await TestHelper.pumpApp();
    SignInBloc signInBloc = TestHelper.getBloc<SignInBloc>();
    await TestHelper.enterDataInTextField(
        data: 'codetrade.io', name: 'Username');
    await TestHelper.enterDataInTextField(data: 'password', name: 'Password');
    await TestHelper.tapButton(finder: find.bySubtype<Checkbox>());
    await TestHelper.tapButton(name: 'Sign in');
    expect(signInBloc.state.runtimeType, SignInSuccess);
    await TestHelper.tapButton(
        finder: find.widgetWithIcon(IconButton, Icons.logout));
    expect(find.text('codetrade.io'), findsOneWidget);
    expect(find.text('password'), findsOneWidget);
  });
}

void signInTest4() {
  testWidgets("Sign In without Remember Me", (WidgetTester tester) async {
    TestHelper.tester = tester;
    await TestHelper.pumpApp();
    SignInBloc signInBloc = TestHelper.getBloc<SignInBloc>();
    await TestHelper.tapButton(finder: find.bySubtype<Checkbox>());
    await TestHelper.tapButton(name: 'Sign in');
    expect(signInBloc.state.runtimeType, SignInSuccess);
    await TestHelper.tapButton(
        finder: find.widgetWithIcon(IconButton, Icons.logout));

    expect(find.text('codetrade.io'), findsNothing);
    expect(find.text('password'), findsNothing);
  });
}
