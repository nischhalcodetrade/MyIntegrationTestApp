import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:integration_test_example_app/src/controller/bloc/home/home_bloc.dart';
import 'package:integration_test_example_app/src/controller/bloc/sign_in/sign_in_bloc.dart';
import 'package:integration_test_example_app/src/controller/bloc/splash/splash_bloc.dart';
import 'package:integration_test_example_app/src/controller/bloc/splash/splash_state.dart';
import 'package:integration_test_example_app/src/controller/db/db.dart';

import '../auth/sign_in/sign_in_screen.dart';
import '../home_screen/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          Future.delayed(const Duration(seconds: 3)).then((value) {
            if (state is AutoSignInSuccess) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BlocProvider<HomeBloc>(
                            create: (context) => HomeBloc(DB.instance()),
                            child: HomeScreen(
                              user: state.user,
                            ),
                          )));
            } else if (state is AutoSignInFailed) {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider<SignInBloc>(
                        create: (context) => SignInBloc(DB.instance()),
                        child: const SignInScreen()),
                  ));
            }
          });
        },
        child: Center(
          child: SizedBox(
            width: 200,
            height: 100,
            child: SvgPicture.asset(
              'assets/svg/codetrade_icon.svg',
            ),
          ),
        ),
      ),
    );
  }
}
