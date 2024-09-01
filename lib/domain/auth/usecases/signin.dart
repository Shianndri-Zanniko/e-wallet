import 'package:dartz/dartz.dart';
import 'package:ewallet/core/usecase/usecase.dart';
import 'package:ewallet/data/auth/models/user_singnin_req.dart';
import 'package:ewallet/domain/auth/repository/auth.dart';
import 'package:ewallet/service_locator.dart';

class SiginUseCase implements UseCase<Either,UserSigninReq> {
  @override
  Future<Either> call({UserSigninReq ? params}) async{
    return sl<AuthRepository>().signin(params!);
  }
  
}