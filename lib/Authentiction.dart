 import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthenticationImp{
  Future<String> signIn(String email,String password);
  Future<String> signUp(String email,String password);
  Future<String> getUserId();
  Future<void> sigOut();
}
class Auth implements AuthenticationImp{
  final FirebaseAuth _firebaseAuth=FirebaseAuth.instance;
  Future<String> signIn(String email,String password) async
  {
    FirebaseUser user=(await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user;
    return user.uid;
  }
  Future<String> signUp(String email,String password) async
  {
    FirebaseUser user=(await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user;
    return user.uid;
  }
  Future<String> getUserId() async {
    FirebaseUser user=_firebaseAuth.currentUser() as FirebaseUser;

    return  user.uid;

  }
  Future<void> sigOut()async{
    _firebaseAuth.signOut();
  }
}