import 'package:ewallet/common/bloc/button/button_state.dart';
import 'package:ewallet/common/bloc/button/button_state_cubit.dart';
import 'package:ewallet/common/widgets/appbar/app_bar.dart';
import 'package:ewallet/common/widgets/button/basic_reactive_button.dart';
import 'package:ewallet/data/auth/models/user_creation_req.dart';
import 'package:ewallet/domain/auth/usecases/signup.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  final TextEditingController _fullnameCon = TextEditingController();
  final TextEditingController _usernameCon = TextEditingController();
  final TextEditingController _phoneCon = TextEditingController();
  final TextEditingController _emailCon = TextEditingController();
  final TextEditingController _passwordCon = TextEditingController();
  final TextEditingController _confirmpasswordCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppbar(hideBack: true,),
      body: BlocProvider(
        create: (context) => ButtonStateCubit(),
        child: BlocListener<ButtonStateCubit, ButtonState>(
          listener: (context, state) {
            if (state is ButtonFailureState) {
              var snackbar = SnackBar(
                content: Text(state.errorMessage),
                behavior: SnackBarBehavior.floating,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
            } else if (state is ButtonSuccessState) {
              var snackbar = const SnackBar(
                content: Text('Signup successful!'),
                behavior: SnackBarBehavior.floating,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackbar);
              Navigator.pushNamed(context, '/home');
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 16
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _signupText(context),
                const SizedBox(height: 20),
                _fullnameField(context),
                const SizedBox(height: 20),
                _usernameField(context),
                const SizedBox(height: 20),
                _phoneField(context),
                const SizedBox(height: 20),
                _emailField(context),
                const SizedBox(height: 20),
                _passwordField(context),
                const SizedBox(height: 20),
                _confirmpasswordField(context),
                const SizedBox(height: 20),
                _finishButton(context),
                const SizedBox(height: 20),
                _loginScreen(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _signupText(BuildContext context) {
    return Text(
      'Sign Up',
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
        fontSize: 32,
        color: Colors.white
      ),
    );
  }

  Widget _fullnameField(BuildContext context) {
    return TextField(
      controller: _fullnameCon,
      style: GoogleFonts.poppins(color: Colors.white),
      decoration: const InputDecoration(
        labelText: 'Full Name',
        filled: true,
        fillColor: Color(0xFF464BD8),
        labelStyle: TextStyle(color: Color(0xFFA1A4EB)),
      ),
    );
  }

  Widget _usernameField(BuildContext context) {
    return TextField(
      controller: _usernameCon,
      style: GoogleFonts.poppins(color: Colors.white),
      decoration: const InputDecoration(
        labelText: 'Username',
        filled: true,
        fillColor: Color(0xFF464BD8),
        labelStyle: TextStyle(color: Color(0xFFA1A4EB)),
      ),
    );
  }

  Widget _phoneField(BuildContext context) {
    return TextField(
      controller: _phoneCon,
      style: GoogleFonts.poppins(color: Colors.white),
      decoration: const InputDecoration(
        labelText: 'Phone Number',
        filled: true,
        fillColor: Color(0xFF464BD8),
        labelStyle: TextStyle(color: Color(0xFFA1A4EB)),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
    );
  }

  Widget _emailField(BuildContext context) {
    return TextField(
      controller: _emailCon,
      style: GoogleFonts.poppins(color: Colors.white),
      decoration: const InputDecoration(
        labelText: 'Email',
        filled: true,
        fillColor: Color(0xFF464BD8),
        labelStyle: TextStyle(color: Color(0xFFA1A4EB)),
      ),
    );
  }

  Widget _passwordField(BuildContext context) {
    return TextField(
      obscureText: true,
      controller: _passwordCon,
      style: GoogleFonts.poppins(color: Colors.white),
      decoration: const InputDecoration(
        labelText: 'Password',
        filled: true,
        fillColor: Color(0xFF464BD8),
        labelStyle: TextStyle(color: Color(0xFFA1A4EB)),
      ),
    );
  }

  Widget _confirmpasswordField(BuildContext context) {
    return TextField(
      obscureText: true,
      controller: _confirmpasswordCon,
      style: GoogleFonts.poppins(color: Colors.white),
      decoration: const InputDecoration(
        labelText: 'Confirm password',
        filled: true,
        fillColor: Color(0xFF464BD8),
        labelStyle: TextStyle(color: Color(0xFFA1A4EB)),
      ),
    );
  }

  Widget _loginScreen(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: GoogleFonts.poppins(),
        children: [
          const TextSpan(
            text: "Already have an account? ",
          ),
          TextSpan(
            text: "Log in",
            recognizer: TapGestureRecognizer()..onTap = () {
              Navigator.pushReplacementNamed(context, '/signin');
            },
            style: const TextStyle(
              fontWeight: FontWeight.bold
            )
          )
        ]
      )
    );
  }

  Widget _finishButton(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 32,
      height: 50,
      child: Center(
        child: Builder(
          builder: (context) {
            return BasicReactiveButton(
              onPressed: () {
                UserCreationReq userCreationReq = UserCreationReq(
                  fullName: _fullnameCon.text,
                  username: _usernameCon.text,
                  phoneNumber: _phoneCon.text,
                  email: _emailCon.text,
                  password: _passwordCon.text,
                  confirmPassword: _confirmpasswordCon.text,
                  balance: '0',
                );
                context.read<ButtonStateCubit>().execute(
                  usecase: SignupUseCase(),
                  params: userCreationReq
                );
              },
              title: 'Finish'
            );
          }
        ),
      ),
    );
  }
}