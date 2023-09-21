import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:integration_test_example_app/src/controller/bloc/sign_in/sign_in_bloc.dart';
import 'package:integration_test_example_app/src/controller/bloc/sign_in/sign_in_event.dart';
import 'package:integration_test_example_app/src/controller/bloc/sign_in/sign_in_state.dart';
import 'package:integration_test_example_app/src/controller/bloc/sign_up/sign_up_bloc.dart';
import 'package:integration_test_example_app/src/controller/db/db.dart';
import 'package:integration_test_example_app/src/model/sign_in_model.dart';
import 'package:integration_test_example_app/src/view/auth/sign_up/sign_up_screen.dart';
import 'package:integration_test_example_app/src/view/home_screen/home_screen.dart';
import 'package:integration_test_example_app/src/view/widgets/buttons/my_button.dart';
import 'package:integration_test_example_app/src/view/widgets/text_fields/my_textfield.dart';

import '../../../controller/bloc/home/home_bloc.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key, this.signInModel});
  final SignInModel? signInModel;
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController userNameController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();

  bool isRememberMe = false;

  @override
  void initState() {
    if (widget.signInModel != null) {
      userNameController.text = widget.signInModel!.userName;
      passwordController.text = widget.signInModel!.password;
      setState(() {
        isRememberMe = widget.signInModel!.isRememberMe;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SignInBloc, SignInState>(
        listener: (context, state) {
          if (state is GetSignInCredentialSuccess) {
            userNameController.text = state.signInModel.userName;
            passwordController.text = state.signInModel.password;
            setState(() {
              isRememberMe = state.signInModel.isRememberMe;
            });
          }
          if (state is SignInSuccess) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => BlocProvider<HomeBloc>(
                          create: (context) => HomeBloc(DB.instance()),
                          child: HomeScreen(
                            user: state.user,
                          ),
                        )));
          } else if (state is SignInFailed) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("${state.error.title}: ${state.error.description}"),
            ));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 200,
                  height: 100,
                  child: SvgPicture.asset(
                    'assets/svg/codetrade_icon.svg',
                  ),
                ),
                MyTextFormField(
                  controller: userNameController,
                  hintText: 'User Name',
                  validator: (value) =>
                      value != '' ? null : 'Please Enter a valid User Name',
                ),
                MyTextFormField(
                  controller: passwordController,
                  hintText: 'Password',
                  validator: (value) =>
                      value != '' ? null : 'Please Enter a valid Password',
                ),
                Row(
                  children: [
                    Checkbox(
                      value: isRememberMe,
                      onChanged: (value) {
                        setState(() {
                          isRememberMe = value!;
                        });
                      },
                    ),
                    const Text('Remember Me'),
                    const Expanded(child: SizedBox()),
                    GestureDetector(
                      child: const Text(
                        'Sign up?',
                        style: TextStyle(color: Colors.blue),
                      ),
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BlocProvider(
                                      create: (context) =>
                                          SignUpBloc(DB.instance()),
                                      child: SignUpScreen(),
                                    )));
                      },
                    )
                  ],
                ),
                MyButton(
                    text: 'Sign in',
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context.read<SignInBloc>().add(SignIn(SignInModel(
                            alreadySignedIn: true,
                            isRememberMe: isRememberMe,
                            userName: userNameController.text,
                            password: passwordController.text)));
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
