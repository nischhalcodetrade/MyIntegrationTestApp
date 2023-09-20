import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:integration_test_example_app/src/controller/bloc/splash/splash_bloc.dart';
import 'package:integration_test_example_app/src/controller/bloc/splash/splash_event.dart';
import 'package:integration_test_example_app/src/controller/db/db.dart';
import 'package:integration_test_example_app/src/view/splash_screen/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DB.instance().initialize();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider<SplashBloc>(
          create: (context) => SplashBloc(DB.instance())..add(AutoSignIn()),
          child: const SplashScreen()),
    );
  }
}
