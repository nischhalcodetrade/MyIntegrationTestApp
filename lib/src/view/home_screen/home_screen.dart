import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:integration_test_example_app/src/controller/bloc/home/home_bloc.dart';
import 'package:integration_test_example_app/src/controller/bloc/home/home_event.dart';
import 'package:integration_test_example_app/src/controller/bloc/home/home_state.dart';
import 'package:integration_test_example_app/src/controller/bloc/sign_in/sign_in_bloc.dart';
import 'package:integration_test_example_app/src/controller/db/db.dart';
import 'package:integration_test_example_app/src/model/user_model.dart';
import 'package:integration_test_example_app/src/view/auth/sign_in/sign_in_screen.dart';
import 'package:integration_test_example_app/src/view/widgets/buttons/my_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.user});
  final UserModel user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hi ${user.firstName} ${user.lastName}'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () => context.read<HomeBloc>().add(SignOut()),
              icon: const Icon(Icons.logout))
        ],
      ),
      body: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is SignOutSuccess) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                      create: (context) => SignInBloc(DB.instance()),
                      child: const SignInScreen()),
                ));
          } else if (state is SignOutFailed) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:
                    Text("${state.error.title}: ${state.error.description}")));
          } else if (state is UserDeleteFailed) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:
                    Text("${state.error.title}: ${state.error.description}")));
          }
        },
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 300,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Username'),
                            Text('First Name'),
                            Text('Last Name'),
                            Text('Gender'),
                            Text('Date of Birth'),
                            Text('Password'),
                          ]),
                      Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user.userName),
                            Text(user.firstName),
                            Text(user.lastName),
                            Text('${user.gender}'),
                            Text('${user.dob}'),
                            Text(user.password),
                          ]),
                    ]),
              ),
              MyButton(
                text: 'Delete User',
                onPressed: () =>
                    context.read<HomeBloc>().add(DeleteUser(user.userName)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
