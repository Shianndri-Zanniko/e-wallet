import 'package:ewallet/common/bloc/button/button_state.dart';
import 'package:ewallet/common/bloc/button/button_state_cubit.dart';
import 'package:ewallet/common/widgets/appbar/app_bar.dart';
import 'package:ewallet/common/widgets/button/basic_reactive_button.dart';
import 'package:ewallet/data/auth/models/user_singnin_req.dart';
import 'package:ewallet/domain/auth/usecases/signin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class EnterPasswordPage extends StatelessWidget {
  final UserSigninReq signinReq;
  EnterPasswordPage({
    required this.signinReq,
    super.key
  });

  final TextEditingController _passwordCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppbar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        child: BlocProvider(
          create: (context) => ButtonStateCubit(),
          child: BlocListener<ButtonStateCubit, ButtonState>(
            listener: (context, state) {
              if (state is ButtonFailureState) {
                var snackbar = SnackBar(content: Text(state.errorMessage), behavior: SnackBarBehavior.floating,);
                ScaffoldMessenger.of(context).showSnackBar(snackbar);
              }

              if (state is ButtonSuccessState) {
                Navigator.pushNamed(context, '/home');
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _signinText(context),
                const SizedBox(height: 20,),
                _passwordField(context),
                const SizedBox(height: 20,),
                _continueButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _signinText(BuildContext context) {
    return Text(
      'Log in',
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.bold,
        fontSize: 32,
        color: Colors.white,
      ),
    );
  }

  Widget _passwordField(BuildContext context) {
    return TextField(
      obscureText: true,
      controller: _passwordCon,
      style: GoogleFonts.poppins(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Password',
        filled: true,
        fillColor: const Color(0xFF464BD8),
        labelStyle: GoogleFonts.poppins(color: const Color(0xFFA1A4EB)),
      ),
    );
  }

  Widget _continueButton(BuildContext context) {
    return Builder(
      builder: (context) {
        return BasicReactiveButton(
          onPressed: () {
            signinReq.password = _passwordCon.text;
            context.read<ButtonStateCubit>().execute(
              usecase: SiginUseCase(),
              params: signinReq
            );
          },
          title: 'Continue'
        );
      }
    );
  }
}