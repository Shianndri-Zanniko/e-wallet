import 'package:dartz/dartz.dart';
import 'package:ewallet/core/usecase/usecase.dart';
import 'package:ewallet/data/auth/models/user_creation_req.dart';
import 'package:ewallet/domain/auth/repository/auth.dart';
import 'package:ewallet/service_locator.dart';

class SignupUseCase implements UseCase<Either,UserCreationReq> {


  @override
  Future<Either> call({UserCreationReq ? params}) async {
    return await sl<AuthRepository>().signup(params!);
  }

  
}