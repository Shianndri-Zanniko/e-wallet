import 'package:ewallet/firebase_options.dart';
import 'package:ewallet/presentation/home/pages/home_page.dart';
import 'package:ewallet/service_locator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ewallet/presentation/auth/pages/signin_page.dart';
import 'package:ewallet/presentation/auth/pages/signup_page.dart';
import 'package:ewallet/presentation/splash/bloc/splash_cubit.dart';
import 'package:ewallet/presentation/splash/pages/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SplashCubit()..appStarted(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFF2F3485)),
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFF2F3485),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashPage(),
          '/signin': (context) => SigninPage(),
          '/signup': (context) => SignupPage(),
          '/home': (context) => const HomePage(),
        },
      ),
    );
  }
}
