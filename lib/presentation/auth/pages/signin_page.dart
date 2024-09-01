import 'package:ewallet/common/helper/navigator/app_navigator.dart';
import 'package:ewallet/common/widgets/appbar/app_bar.dart';
import 'package:ewallet/common/widgets/button/basic_app_button.dart';
import 'package:ewallet/data/auth/models/user_singnin_req.dart';
import 'package:ewallet/presentation/auth/pages/enter_password_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; 

class SigninPage extends StatelessWidget {
  SigninPage({super.key});
  
  final TextEditingController _usernameCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BasicAppbar(hideBack: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _signinText(context),
            const SizedBox(height: 20),
            _usernameField(context),
            const SizedBox(height: 20),
            _continueButton(context),
            const SizedBox(height: 20),
            _createAccount(context)
          ],
        ),
      )
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

  Widget _usernameField(BuildContext context) {
    return TextField(
      style: GoogleFonts.poppins(color: Colors.white),
      controller: _usernameCon,
      decoration: InputDecoration(
        labelText: 'Email',
        filled: true,
        fillColor: const Color(0xFF464BD8),
        labelStyle: GoogleFonts.poppins(color: const Color(0xFFA1A4EB)),
      ),
    );
  }

  Widget _continueButton(BuildContext context) {
    return BasicAppButton(
      onPressed: (){
        AppNavigator.push(
          context, 
          EnterPasswordPage(
            signinReq: UserSigninReq(
              email: _usernameCon.text,
            ),
          )
        );
      },
      title: 'Continue'
    );
  }

  Widget _createAccount(BuildContext context) {
    return RichText(
      text: TextSpan( 
        style: GoogleFonts.poppins(color: Colors.white),
        children: [
          TextSpan(
            text: "Don't have an account? ",
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          TextSpan(
            text: "Sign Up",
            recognizer: TapGestureRecognizer()..onTap = () {
              Navigator.pushReplacementNamed(context, '/signup');
            },
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          )
        ]
      ),
    );
  }
}