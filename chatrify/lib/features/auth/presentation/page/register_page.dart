import 'package:chatrify/features/auth/presentation/bloc/auth_event.dart';
import 'package:chatrify/features/auth/presentation/bloc/auth_state.dart';
import 'package:chatrify/features/auth/presentation/widget/auth_button.dart';
import 'package:chatrify/features/auth/presentation/widget/auth_input_field.dart';
import 'package:chatrify/features/auth/presentation/widget/login_prompt.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _showInputValues() {
    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    print("Username: $username - Email: $email - Password: $password");
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onRegister() {
      BlocProvider.of<AuthBloc>(context).add(
        RegisterEvent(
            username: _usernameController.text,
            email: _emailController.text,
            password: _passwordController.text
        )
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthInputField(hint: 'Корисничко име', icon: Icons.person, controller: _usernameController),
              SizedBox(height: 20,),
              AuthInputField(hint: 'Емаил', icon: Icons.email, controller: _emailController),
              SizedBox(height: 20,),
              AuthInputField(hint: 'Лозинка', icon: Icons.lock, controller: _passwordController, isPassword: true),
              SizedBox(height: 20,),
              BlocConsumer<AuthBloc, AuthState>(
                builder: (context, state) {
                  if(state is AuthLoading) {
                    return Center(child: CircularProgressIndicator(),);
                  }

                  return AuthButton(
                      text: 'Регистрирајте се',
                      onPressed: _onRegister
                  );
                },
                listener: (context, state) {
                  if(state is AuthSuccess) {
                    Navigator.pushNamed(context, '/login');
                  } else if(state is AuthFailure) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error))
                    );
                  }
                }
              ),
              SizedBox(height: 20,),
              LoginPrompt(title: 'Веќе сте регистрирани? ', subtitle: 'Најавете се', onTap: (){
                Navigator.pushNamed(context, '/login');
              })
            ]
          )
        )
      )
    );
  }
}
