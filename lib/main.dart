import 'package:flutter/material.dart';
 import 'Mapping.dart';
 import 'Authentiction.dart';
void main(){
  runApp(new BlogApp());
}
class BlogApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Blogger App",
      theme: new ThemeData(
        primarySwatch: Colors.pink,
      ),
//      home: LoginRegister(),
    home: MappingPage(auth: Auth(),),
    );
  }

}