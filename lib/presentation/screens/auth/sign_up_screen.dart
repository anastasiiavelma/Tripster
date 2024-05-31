import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tripster/presentation/cubits/auth_cubit/auth_cubit.dart';
import 'package:tripster/presentation/cubits/auth_cubit/auth_state.dart';
import 'package:tripster/data/repository/auth_repository.dart';
import 'package:tripster/presentation/widgets/headers/header_widget.dart';
import 'package:tripster/presentation/widgets/buttons/text_button.dart';
import 'package:tripster/presentation/screens/auth/sign_in_screen.dart';
import 'package:tripster/presentation/widgets/snack_bar_widget.dart';
import 'package:tripster/utils/languages/generated/locale_keys.g.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthRepository _authRepository = AuthRepository();
  late final TextEditingController _passwordController;
  late final TextEditingController _emailController;
  late final TextEditingController _confirmPasswordController;
  late final TextEditingController _nameController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _emailController = TextEditingController();
    _nameController = TextEditingController();
    _confirmPasswordController = TextEditingController();
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
                Navigator.pushNamed(context, '/menu', arguments: token);
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
                      title: LocaleKeys.register.tr(),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                      child: Column(
                        children: <Widget>[
                          RegisterFormWidget(
                            emailController: _emailController,
                            nameController: _nameController,
                            passwordController: _passwordController,
                            confirmPasswordController:
                                _confirmPasswordController,
                            formKey: _formKey,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextAccentButton(
                            state: state,
                            onTap: () async {
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthCubit>().registerUser(
                                      _nameController.text.trim(),
                                      _emailController.text.trim(),
                                      _passwordController.text.trim(),
                                    );
                              }
                            },
                            child: Text(
                              LocaleKeys.register.tr(),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const HaveAccButtonWidget(),
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

class RegisterFormWidget extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController passwordController;
  final TextEditingController emailController;
  final TextEditingController confirmPasswordController;
  final GlobalKey<FormState> formKey;
  const RegisterFormWidget({
    super.key,
    required this.nameController,
    required this.passwordController,
    required this.emailController,
    required this.formKey,
    required this.confirmPasswordController,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
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
                    style: TextStyle(color: Colors.black),
                    controller: nameController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return LocaleKeys.register_enter_name.tr();
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: LocaleKeys.name.tr(),
                        hintStyle: Theme.of(context).textTheme.bodyMedium),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Theme.of(context).colorScheme.shadow))),
                  child: TextFormField(
                    style: TextStyle(color: Colors.black),
                    controller: emailController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return LocaleKeys.invalid_email.tr();
                      } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return LocaleKeys.invalid_email.tr();
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: LocaleKeys.email.tr(),
                        hintStyle: Theme.of(context).textTheme.bodyMedium),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              color: Theme.of(context).colorScheme.shadow))),
                  child: TextFormField(
                    obscureText: true,
                    style: TextStyle(color: Colors.black),
                    controller: passwordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return LocaleKeys.register_enter_password.tr();
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: LocaleKeys.password.tr(),
                        hintStyle: Theme.of(context).textTheme.bodyMedium),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    style: TextStyle(color: Colors.black),
                    controller: confirmPasswordController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return LocaleKeys.register_enter_password.tr();
                      } else if (value != passwordController.text) {
                        return LocaleKeys.register_passwords_no_match.tr();
                      }
                      return null;
                    },
                    obscureText: true,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: LocaleKeys.confirm_password.tr(),
                        hintStyle: Theme.of(context).textTheme.bodyMedium),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

class HaveAccButtonWidget extends StatelessWidget {
  const HaveAccButtonWidget({
    Key? key,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: const Duration(milliseconds: 2000),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(LocaleKeys.have_an_account.tr(),
              style: Theme.of(context).textTheme.headlineSmall),
          TextButton(
            child: Text(
              LocaleKeys.sign_in.tr(),
              style: Theme.of(context).textTheme.titleSmall,
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SignInScreen(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
