import 'package:dartz/dartz.dart';
import 'package:ewallet/data/auth/models/user_creation_req.dart';
import 'package:ewallet/data/auth/models/user_singnin_req.dart';
import 'package:ewallet/data/auth/source/auth_firebase_service.dart';
import 'package:ewallet/domain/auth/repository/auth.dart';
import 'package:ewallet/service_locator.dart';

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<Either> signup(UserCreationReq user) {
    return sl<AuthFirebaseService>().signup(user); 
  }

  @override
  Future<Either> signin(UserSigninReq user) {
    return sl<AuthFirebaseService>().signin(user); 
  }

}