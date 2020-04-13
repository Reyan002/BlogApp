import 'package:flutter/material.dart';
import 'HomePage.dart';
import 'LoginRegister.dart';
import 'Authentiction.dart';

class MappingPage extends StatefulWidget
{
  final AuthenticationImp auth;

  MappingPage({
    this.auth,

});
  @override
  State<StatefulWidget> createState() {

    return _MappingPageState();
  }

}

enum AuthStatus{
  notSignIn,
  signIn

}
class _MappingPageState extends State<MappingPage> {
  AuthStatus authStatus=AuthStatus.notSignIn;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.auth.getUserId().then((firebaseUserId){

      setState(() {
        authStatus=firebaseUserId==null ? AuthStatus.notSignIn : AuthStatus.signIn;
      });
    });
  }
  @override
  Widget build(BuildContext context) {

    switch(authStatus){
      case AuthStatus.notSignIn:
        return new LoginRegister(
          auth:widget.auth,
          onSignedIn: signedIn,
        );
      case AuthStatus.signIn:
        return new HomePage(
          auth:widget.auth,
          onSignOut: signOut,
        );
//        break;
    }


     return null;
  }
  void signedIn() {
    setState(() {
      authStatus=AuthStatus.signIn;
    });
  }

  void signOut() {
    setState(() {
      authStatus=AuthStatus.notSignIn;
    });
  }
}