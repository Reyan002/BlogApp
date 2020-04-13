 import 'package:blogapp/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UploadImage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _UploadImageState();
  }

}

class _UploadImageState extends State<UploadImage> {

  String url;
  File sampleImage;
  String _myValue;
  final formKey=new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Upload Blog"),
        centerTitle: true,

      ),
      body: new Center(
        child: sampleImage==null ? Text("Select an Image"): enableUpload(),
      ),
      floatingActionButton: new FloatingActionButton(onPressed: getImage,
        tooltip: "Add Image",
        child: new Icon(Icons.add_a_photo),
      ),
    );
  }
  Widget enableUpload(){

    return
    Container(
      child:
      new Form(key: formKey,
        child: Column(
          children: <Widget>[

            Image.file(sampleImage,height:330 ,width: 660,),
            SizedBox(height: 15),
            TextFormField(decoration: new InputDecoration(labelText: "Description"),
              validator:(value){
                return value.isEmpty ? "Blog Description Is Required" : null;
              },
              onSaved: (value){
                return _myValue=value;
              },
            ),
            SizedBox(height: 15),
            RaisedButton(
              elevation: 10,
              child: Text("Add a Post"),
              color: Colors.pink,
              textColor: Colors.white,
              onPressed: uploadMyImage,
            )
          ],
        ),
      )
      ,
    );

  }

  Future getImage() async{
    var tempImage=await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      sampleImage=tempImage;
    });
  }

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

  void uploadMyImage() async{
    if(validateAndSave()){
      final StorageReference postImageRef=FirebaseStorage.instance.ref().child("Post Images");
      var timeKey=new DateTime.now();
      final StorageUploadTask uploadTask=postImageRef.child(timeKey.toString()+".jpg").putFile(sampleImage);
      var ImageUrl=await (await uploadTask.onComplete).ref.getDownloadURL();
      url=ImageUrl.toString();
      print(url);
      gotoHome();
      saveToDatabase(url);


    }
  }

  void saveToDatabase(String url) {
    var dbTimeKey=new DateTime.now();
    var formatDate=new DateFormat("MMM dd, yyyy");
    var formatTime=new DateFormat("EEEE, hh:mm aaa");

    String date=formatDate.format(dbTimeKey);
    String time=formatTime.format(dbTimeKey);

    DatabaseReference reference=FirebaseDatabase.instance.reference();
    var Data={
      "image": url,
      "description": _myValue,
      "date": time,
      "time":time
    };
    reference.child("Post").push().set(Data);


  }

  void gotoHome() {
    Navigator.push(context,
    MaterialPageRoute(builder: (context){
      return new HomePage();
    })
    );
  }
}