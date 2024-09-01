import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_creation_req.dart';
import '../models/user_singnin_req.dart';

abstract class AuthFirebaseService {
  Future<Either> signup(UserCreationReq user);
  Future<Either> signin(UserSigninReq user);
}

class AuthFirebaseServiceImpl extends AuthFirebaseService {
  @override
  Future<Either> signup(UserCreationReq user) async {
    try {
      if (user.fullName == null || user.fullName!.length < 5) {
        throw FirebaseAuthException(
          code: 'invalid-full-name',
        );
      } else if (user.password != user.confirmPassword) {
        throw FirebaseAuthException(
          code: 'not-matching-password',
        );
      }

      var userQuery = await FirebaseFirestore.instance
          .collection('Users')
          .where('username', isEqualTo: user.username)
          .get();

      if (userQuery.docs.isNotEmpty) {
        throw FirebaseAuthException(
          code: 'username-already-in-use',
        );
      }

      var returnedData = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: user.email!,
        password: user.password!,
      );

      await FirebaseFirestore.instance.collection('Users').doc(returnedData.user!.uid).set({
        'fullName': user.fullName,
        'username': user.username,
        'phoneNumber': user.phoneNumber,
        'balance': user.balance,
      });

      return const Right('Signup Successfully!');
    } on FirebaseAuthException catch (e) {
      String message = '';

      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        message = 'The email provided is not valid.';
      } else if (e.code == 'invalid-full-name') {
        message = 'Full name must be at least 5 characters long.';
      } else if (e.code == 'not-matching-password') {
        message = 'Passwords do not match.';
      } else if (e.code == 'username-already-in-use') {
        message = 'The username is already in use.';
      }

      return Left(message);
    }
  }

  @override
  Future<Either> signin(UserSigninReq user) async {
    try {

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: user.email!,
        password: user.password!,
      );

      return const Right('Signin Successfully!');
    } on FirebaseAuthException catch (e) {
      String message = '';

      if (e.code == 'invalid-email') {
        message = 'The email provided is not valid.';
      } else if (e.code == 'invalid-credential') {
        message = 'The password provided is not valid.';
      } else if (e.code == 'invalid-username') {
        message = 'The username provided is not valid.';
      }

      return Left(message);
    }
  }
}