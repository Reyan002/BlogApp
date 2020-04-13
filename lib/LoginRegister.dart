import 'package:flutter/material.dart';
import 'Authentiction.dart';
import 'DialogBox.dart';

class LoginRegister extends StatefulWidget{
  LoginRegister({

    this.auth,this.onSignedIn
});
  final AuthenticationImp auth;
  final VoidCallback onSignedIn;
  State<StatefulWidget> createState( )
  {
    return _LoginState();
  }
}
enum FormType{
  login,
  register
}

class _LoginState extends State<LoginRegister> {

  final formKey= new GlobalKey<FormState>();

  DialogBox dialogBox = new DialogBox();
  FormType formType=FormType.login;
  String _email="";
  String _password="";
  bool validateAndSave() {
    final form=formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }
    else{
      return false;
    }
  }
  void validateAndSubmit() async{
    if(validateAndSave()){
      try{
        if(formType==FormType.login){
          String userId= await widget.auth.signIn(_email, _password);
          dialogBox.information(context, "Congratulations", "You are Succesfully Logged In");
          print("Login User Id ="+ userId);
        }else{
          String userId= await widget.auth.signUp(_email, _password);
          dialogBox.information(context, "Congratulations", "Your account has been created");
          print("Login User Id ="+ userId);
        }
        widget.onSignedIn();

      }catch(e){

        print("Error ="+ e.toString());

        dialogBox.information(context, "Error", e.toString());
      }
    }
  }

  void goTORegister() {
    formKey.currentState.reset();
    setState(() {
      formType=FormType.register;
    });
  }
  void goTOLogin() {
    formKey.currentState.reset();
    setState(() {
      formType=FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        title: new Text( "Flutter Blogging App"),
      ),
      body: new Container(
        margin: EdgeInsets.all(10.0),
        child: new Form(
          key: formKey,
          child: new Column(

            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: createInput()+createButtton(),
          ),
        ),
      ),
    );
  }


  List<Widget> createInput(){
    return[

       SizedBox(height: 10,),
      logo(),
      SizedBox(height: 20,),
      new TextFormField(
        decoration: new InputDecoration(labelText: "Email"),
        validator: (value){
          return value.isEmpty ? "Email is Required": null;
        },
        onSaved: (value){
          _email=value;


        }

      ),
      SizedBox(height: 10,),
      new TextFormField(
        decoration: new InputDecoration(labelText: "Password"),
          obscureText: true,
          validator: (value){
            return value.isEmpty ? "Password is Required": null;
          },
          onSaved: (value){
            _password=value;


          }
      ),
      SizedBox(height: 20,),
    ];
  }
  Widget logo(){
    return new Hero(tag: 'hero', child: new CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: 110.0,
      child: Image.asset('images/applogo.png'),
    ));

  }
  List<Widget> createButtton(){
    if(formType==FormType.login) {
      return [
        new RaisedButton(
          child: new Text("Login", style: new TextStyle(fontSize: 16),),

          textColor: Colors.white,
          color: Colors.pink,
          onPressed: validateAndSubmit,

        )
        ,
        new FlatButton(
          child: new Text("Dont Have an Account? Create an Account",
            style: new TextStyle(fontSize: 16),),
          textColor: Colors.pink,
          onPressed: goTORegister,


        )

      ];
    }
    else{
      return [
        new RaisedButton(
          child: new Text("Register", style: new TextStyle(fontSize: 16),),

          textColor: Colors.white,
          color: Colors.pink,
          onPressed: validateAndSubmit,

        )
        ,
        new FlatButton(
          child: new Text("Already Have an Account? Login",
            style: new TextStyle(fontSize: 16),),
          textColor: Colors.pink,
          onPressed: goTOLogin,


        )

      ];
    }
  }



}