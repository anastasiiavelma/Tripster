import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripster/presentation/cubits/auth_cubit/auth_cubit.dart';
import 'package:tripster/presentation/cubits/auth_cubit/auth_state.dart';
import 'package:tripster/data/repository/auth_repository.dart';
import 'package:tripster/presentation/widgets/headers/header_widget.dart';
import 'package:tripster/presentation/widgets/buttons/text_button.dart';
import 'package:tripster/presentation/screens/auth/sign_up_screen.dart';
import 'package:tripster/presentation/widgets/snack_bar_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tripster/utils/constants.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final AuthRepository _authRepository = AuthRepository();
  late final TextEditingController _passwordController;
  late final TextEditingController _emailController;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: BlocProvider(
          create: (context) => AuthCubit(_authRepository),
          child: BlocConsumer<AuthCubit, AuthState>(
            listener: (context, state) {
              if (state is AuthLoading) {
              } else if (state is AuthAuthenticated) {
                final token = state.token;
                print('================');
                print(token);
                Navigator.pushReplacementNamed(context, '/menu',
                    arguments: token);
              } else if (state is AuthError) {
                CustomSnackBar.show(
                  context,
                  message: state.message,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                );
              }
            },
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    HeaderWidget(
                      title: 'Login',
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 0.0, 20.0, 20.0),
                      child: Column(
                        children: <Widget>[
                          LoginFormsWidget(
                            passwordController: _passwordController,
                            emailController: _emailController,
                            formKey: _formKey,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextAccentButton(
                            state: state,
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthCubit>().loginUser(
                                      _emailController.text.trim(),
                                      _passwordController.text.trim(),
                                    );
                              }
                            },
                            child: Text(
                              "Login",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          const SizedBox(
                            height: 70,
                          ),
                          HaveAccWidget(),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ));
  }
}

class LoginFormsWidget extends StatefulWidget {
  final TextEditingController passwordController;
  final TextEditingController emailController;
  final GlobalKey<FormState> formKey;

  LoginFormsWidget({
    super.key,
    required this.passwordController,
    required this.emailController,
    required this.formKey,
  });

  @override
  State<LoginFormsWidget> createState() => _LoginFormsWidgetState();
}

class _LoginFormsWidgetState extends State<LoginFormsWidget> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: FadeInUp(
          duration: const Duration(milliseconds: 1800),
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).colorScheme.shadow,
                      blurRadius: 20.0,
                      offset: Offset(0, 10))
                ]),
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Theme.of(context).colorScheme.shadow))),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                    style: TextStyle(color: Colors.black),
                    controller: widget.emailController,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Email",
                        hintStyle: Theme.of(context).textTheme.bodyMedium),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    style: TextStyle(color: Colors.black),
                    controller: widget.passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Password",
                      hintStyle: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

class HaveAccWidget extends StatelessWidget {
  const HaveAccWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 2000),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Don't have an account?",
              style: Theme.of(context).textTheme.headlineSmall),
          TextButton(
            child: Text(
              "Sign Up",
              style: Theme.of(context).textTheme.titleSmall,
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SignUpScreen(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginHeaderWidget extends StatelessWidget {
  const LoginHeaderWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/background.png'),
              fit: BoxFit.fill)),
      child: Stack(
        children: <Widget>[
          Positioned(
            top: 35,
            right: 170,
            width: 400,
            height: 200,
            child: FadeInUp(
                duration: const Duration(seconds: 1),
                child: Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/airplane8.png'))),
                )),
          ),
          Positioned(
            left: 170,
            top: 100,
            width: 400,
            height: 150,
            child: FadeInUp(
                duration: const Duration(milliseconds: 1300),
                child: Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/bagage.png'))),
                )),
          ),
          FadeInUp(
            duration: const Duration(milliseconds: 1600),
            child: Center(
              child: Text(
                "Login",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
