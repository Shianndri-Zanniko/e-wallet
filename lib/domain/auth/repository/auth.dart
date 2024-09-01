import 'package:dartz/dartz.dart';
import 'package:ewallet/data/auth/models/user_creation_req.dart';
import 'package:ewallet/data/auth/models/user_singnin_req.dart';

abstract class AuthRepository {
  Future <Either> signup(UserCreationReq user);
  Future <Either> signin(UserSigninReq user);

}