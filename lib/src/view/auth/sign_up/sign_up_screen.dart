import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:integration_test_example_app/src/controller/bloc/sign_in/sign_in_event.dart';
import 'package:integration_test_example_app/src/controller/bloc/sign_up/sign_up_bloc.dart';
import 'package:integration_test_example_app/src/controller/bloc/sign_up/sign_up_event.dart';
import 'package:integration_test_example_app/src/controller/bloc/sign_up/sign_up_state.dart';
import 'package:integration_test_example_app/src/model/user_model.dart';
import 'package:integration_test_example_app/src/view/auth/sign_in/sign_in_screen.dart';
import 'package:integration_test_example_app/src/view/widgets/buttons/my_button.dart';
import 'package:integration_test_example_app/src/view/widgets/text_fields/my_textfield.dart';

import '../../../controller/bloc/sign_in/sign_in_bloc.dart';
import '../../../controller/db/db.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController userNameController = TextEditingController();

  final TextEditingController firstNameController = TextEditingController();

  final TextEditingController lastNameController = TextEditingController();

  final TextEditingController dobController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  DateTime? dob;

  Gender? gender;

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SignUpBloc, SignUpState>(
        listener: (context, state) {
          if (state is SignUpSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("New User Created"),
            ));
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider<SignInBloc>(
                      create: (context) => SignInBloc(DB.instance()),
                      child: const SignInScreen()),
                ));
          } else if (state is SignUpFailed) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("${state.error.title}: ${state.error.description}"),
            ));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(
                  height: 100,
                ),
                Center(
                  child: SizedBox(
                    width: 200,
                    height: 100,
                    child: SvgPicture.asset(
                      'assets/svg/codetrade_icon.svg',
                    ),
                  ),
                ),
                MyTextFormField(
                  controller: userNameController,
                  hintText: 'Username',
                  validator: (value) =>
                      value != '' ? null : 'Please Enter a valid User Name',
                ),
                MyTextFormField(
                  controller: firstNameController,
                  hintText: 'First Name',
                  validator: (value) =>
                      value != '' ? null : 'Please Enter a valid First Name',
                ),
                MyTextFormField(
                  controller: lastNameController,
                  hintText: 'Last Name',
                  validator: (value) =>
                      value != '' ? null : 'Please Enter a valid Last Name',
                ),
                MyTextFormField(
                  controller: dobController,
                  hintText: 'Date of Birth',
                  validator: (value) =>
                      value != '' ? null : 'Please Enter a valid Date of Birth',
                  onTap: () async {
                    dob = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now());
                    if (dob != null) {
                      dobController.text =
                          "${dob!.day}/${dob!.month}/${dob!.year}";
                    }
                  },
                ),
                DropdownButtonFormField<Gender>(
                  hint: const Text('Gender'),
                  items: const [
                    DropdownMenuItem(
                      value: Gender.male,
                      child: Text('Male'),
                    ),
                    DropdownMenuItem(
                      value: Gender.female,
                      child: Text('Female'),
                    )
                  ],
                  onChanged: (value) {
                    gender = value!;
                  },
                  validator: (value) {
                    return value != null ? null : 'Please select a gender';
                  },
                ),
                MyTextFormField(
                  controller: passwordController,
                  hintText: 'Password',
                  validator: (value) =>
                      value != '' ? null : 'Please Enter a valid Password',
                ),
                MyTextFormField(
                  controller: TextEditingController(),
                  hintText: 'Confirm Password',
                  validator: (value) => value != ''
                      ? value == passwordController.text
                          ? null
                          : 'Password and Confirm password do not match'
                      : 'Please Enter a valid Password',
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    const Expanded(child: SizedBox()),
                    GestureDetector(
                      child: const Text(
                        'Sign in?',
                        style: TextStyle(color: Colors.blue),
                      ),
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BlocProvider<SignInBloc>(
                                      create: (context) =>
                                          SignInBloc(DB.instance())
                                            ..add(GetSignInCredential()),
                                      child: const SignInScreen(),
                                    )));
                      },
                    )
                  ],
                ),
                MyButton(
                    text: 'Sign up',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<SignUpBloc>().add(SignUp(UserModel(
                            firstName: firstNameController.text,
                            lastName: lastNameController.text,
                            dob: dob!,
                            gender: gender!,
                            password: passwordController.text,
                            userName: userNameController.text)));
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
