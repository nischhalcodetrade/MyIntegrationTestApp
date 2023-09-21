import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test_example_app/src/controller/bloc/sign_up/sign_up_bloc.dart';
import 'package:integration_test_example_app/src/controller/bloc/sign_up/sign_up_state.dart';
import 'package:integration_test_example_app/src/model/user_model.dart';

import '../../../utils/testing_helper.dart';

void signUpTest1() {
  testWidgets("Form Validation Test", (WidgetTester tester) async {
    TestHelper.tester = tester;
    await TestHelper.pumpApp();
    await TestHelper.tapButton(finder: find.text('Sign up?'));
    await TestHelper.tapButton(name: 'Sign up');
    expect(find.text('Please Enter a valid Username'), findsOneWidget);
    expect(find.text('Please Enter a valid First Name'), findsOneWidget);
    expect(find.text('Please Enter a valid Last Name'), findsOneWidget);
    expect(find.text('Please Enter a valid Date of Birth'), findsOneWidget);
    expect(find.text('Please select a gender'), findsOneWidget);
    expect(find.text('Please Enter a valid Password'), findsNWidgets(2));
  });
}

void signUpTest2() {
  testWidgets("Password Confirm Password do not Match",
      (WidgetTester tester) async {
    TestHelper.tester = tester;
    await TestHelper.pumpApp();
    await TestHelper.tapButton(finder: find.text('Sign up?'));
    await TestHelper.enterDataInTextField(
        data: 'codetrade.io', name: 'Username');
    await TestHelper.enterDataInTextField(
        data: 'Codetrade', name: 'First Name');
    await TestHelper.enterDataInTextField(data: 'Io', name: 'Last Name');
    await TestHelper.tapButton(
        finder: find.widgetWithText(TextField, 'Date of Birth').first);
    await TestHelper.tapButton(finder: find.text('1').first);
    await TestHelper.tapButton(finder: find.text('OK').first);
    await TestHelper.selectDataInDropdown<Gender>(name: 'Gender');
    await TestHelper.enterDataInTextField(data: 'password', name: 'Password');
    await TestHelper.enterDataInTextField(
        data: 'pasword', name: 'Confirm Password');
    await TestHelper.tapButton(name: 'Sign up');
    expect(find.text('Password and Confirm password do not match'),
        findsOneWidget);
  });
}

void signUpTest3() {
  testWidgets("New User Creation Test", (WidgetTester tester) async {
    TestHelper.tester = tester;
    await TestHelper.pumpApp();
    await TestHelper.tapButton(finder: find.text('Sign up?'));
    SignUpBloc signUpBloc = TestHelper.getBloc<SignUpBloc>();
    await TestHelper.enterDataInTextField(
        data: 'codetrade.io', name: 'Username');
    await TestHelper.enterDataInTextField(
        data: 'Codetrade', name: 'First Name');
    await TestHelper.enterDataInTextField(data: 'Io', name: 'Last Name');
    await TestHelper.tapButton(
        finder: find.widgetWithText(TextField, 'Date of Birth').first);
    await TestHelper.tapButton(finder: find.text('1').first);
    await TestHelper.tapButton(finder: find.text('OK').first);
    await TestHelper.selectDataInDropdown<Gender>(name: 'Gender');
    await TestHelper.enterDataInTextField(data: 'password', name: 'Password');
    await TestHelper.enterDataInTextField(
        data: 'password', name: 'Confirm Password');
    await TestHelper.tapButton(name: 'Sign up');
    expect(signUpBloc.state.runtimeType, SignUpSuccess);
  });
}

void signUpTest4() {
  testWidgets("Duplicate User Creation Test", (WidgetTester tester) async {
    TestHelper.tester = tester;
    await TestHelper.pumpApp();
    await TestHelper.tapButton(finder: find.text('Sign up?'));
    SignUpBloc signUpBloc = TestHelper.getBloc<SignUpBloc>();
    await TestHelper.enterDataInTextField(
        data: 'codetrade.io', name: 'Username');
    await TestHelper.enterDataInTextField(
        data: 'Codetrade', name: 'First Name');
    await TestHelper.enterDataInTextField(data: 'Io', name: 'Last Name');
    await TestHelper.tapButton(
        finder: find.widgetWithText(TextField, 'Date of Birth').first);
    await TestHelper.tapButton(finder: find.text('1').first);
    await TestHelper.tapButton(finder: find.text('OK').first);
    await TestHelper.selectDataInDropdown<Gender>(name: 'Gender');
    await TestHelper.enterDataInTextField(data: 'password', name: 'Password');
    await TestHelper.enterDataInTextField(
        data: 'password', name: 'Confirm Password');
    await TestHelper.tapButton(name: 'Sign up');
    expect(signUpBloc.state.runtimeType, SignUpFailed);
    expect(find.bySubtype<SnackBar>(), findsOneWidget);
  });
}
