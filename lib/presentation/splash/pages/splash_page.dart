import 'package:ewallet/core/configs/assets/app_vector.dart';
import 'package:ewallet/presentation/splash/bloc/splash_cubit.dart';
import 'package:ewallet/presentation/splash/bloc/splash_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (context, state) {
        if(state is Unauthenticated){
          Navigator.pushReplacementNamed(context, '/signin');
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF2F3485),
        body: Center(
          child: SvgPicture.asset(AppVector.appLogo),
        ),
      ),
    );
  }
}
