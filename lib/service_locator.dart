

import 'package:ewallet/data/auth/repository/auth_repository_impl.dart';
import 'package:ewallet/data/auth/source/auth_firebase_service.dart';
import 'package:ewallet/domain/auth/repository/auth.dart';
import 'package:ewallet/domain/auth/usecases/signin.dart';
import 'package:ewallet/domain/auth/usecases/signup.dart';
import 'package:get_it/get_it.dart';


final sl = GetIt.instance;

Future<void> initializeDependencies() async {

  // Services
  
  sl.registerSingleton<AuthFirebaseService>(
    AuthFirebaseServiceImpl()
  );


  // Repositories

  sl.registerSingleton<AuthRepository>(
    AuthRepositoryImpl()
  );


  // Usecases

  sl.registerSingleton<SignupUseCase>(
    SignupUseCase()
  );

  sl.registerSingleton<SiginUseCase>(
    SiginUseCase()
  );

}
