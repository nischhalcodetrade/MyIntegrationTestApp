import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:integration_test_example_app/src/controller/bloc/home/home_bloc.dart';
import 'package:integration_test_example_app/src/controller/bloc/home/home_event.dart';
import 'package:integration_test_example_app/src/controller/bloc/home/home_state.dart';
import 'package:integration_test_example_app/src/controller/bloc/sign_in/sign_in_bloc.dart';
import 'package:integration_test_example_app/src/controller/bloc/sign_in/sign_in_event.dart';
import 'package:integration_test_example_app/src/controller/db/db.dart';
import 'package:integration_test_example_app/src/model/user_model.dart';
import 'package:integration_test_example_app/src/view/auth/sign_in/sign_in_screen.dart';
import 'package:integration_test_example_app/src/view/widgets/buttons/my_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.user});
  final UserModel user;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    FocusManager.instance.primaryFocus?.unfocus();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hi ${widget.user.firstName} ${widget.user.lastName}'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () =>
                  context.read<HomeBloc>().add(SignOut(widget.user.userName)),
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
                      create: (context) =>
                          SignInBloc(DB.instance())..add(GetSignInCredential()),
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ConstrainedBox(
              constraints:
                  BoxConstraints.tight(const Size(double.infinity, 300)),
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
                          Text(widget.user.userName),
                          Text(widget.user.firstName),
                          Text(widget.user.lastName),
                          Text('${widget.user.gender}'),
                          Text('${widget.user.dob}'),
                          Text(widget.user.password),
                        ]),
                  ]),
            ),
            MyButton(
              text: 'Delete User',
              onPressed: () => context
                  .read<HomeBloc>()
                  .add(DeleteUser(widget.user.userName)),
            )
          ],
        ),
      ),
    );
  }
}
