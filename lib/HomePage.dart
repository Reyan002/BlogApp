import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'Authentiction.dart';
import 'PhotoUpload.dart';
import 'Posts.dart';

class HomePage extends StatefulWidget{
  HomePage({

    this.auth,this.onSignOut
  });
  final AuthenticationImp auth;
  final VoidCallback onSignOut;
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomePageState();
  }

}

class HomePageState extends State<HomePage> {
  List<Posts> postList=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DatabaseReference reference=FirebaseDatabase.instance.reference().child("Post");
    reference.once().then((DataSnapshot snap)
    {
      var KEY=snap.value.keys;
      var DATA=snap.value;
      postList.clear();
      for(var individualKey in KEY){
        Posts posts=new Posts(
          DATA[individualKey]['image'],
          DATA[individualKey]['description'],
          DATA[individualKey]['date'],
          DATA[individualKey]['time'],
        );

        postList.add(posts);
      }
    }
    );
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar:
      new AppBar(title: new Text("Home",textAlign: TextAlign.center,),

      ),
      body: new Container(
        child: postList.length==0 ?new Text("No Post Is Available"):
        new ListView.builder(itemCount: postList.length,
            itemBuilder:(_,index){
          return PostUI(postList[index].image, postList[index].description, postList[index].date,postList[index]. time);
        }),

      ),
      bottomNavigationBar: new BottomAppBar(
        color: Colors.pink,
        child: new Container(
          margin: const EdgeInsets.only(left: 50,right: 50),
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new IconButton(icon: new Icon(Icons.local_car_wash), onPressed: logoutUser,iconSize: 30,color: Colors.white,),
              new IconButton(icon: new Icon(Icons.add_a_photo), onPressed: ( ){
                Navigator.push(context,
                   MaterialPageRoute(builder: (context){
                     return new UploadImage();
                   }
                   )
                );
              },iconSize: 30,color: Colors.white,),
//              new IconButton(icon: new Icon(Icons.access_alarms), onPressed: null,iconSize: 40,color: Colors.white,),

            ],
          ),
        ),
      ),
    );
  }

  void logoutUser() async {
    try{
        await widget.auth.sigOut();
        widget.onSignOut();

    }catch(e){
      print(e.toString());
    }
  }
  void addAphoto() {
  }

  Widget PostUI(String image,String description,String date, String time ){
    return new Card(
      elevation: 10.0,
      margin: EdgeInsets.all(10.0),
      child: new Container(
       padding: new EdgeInsets.all(10.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
           new Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: <Widget>[
             new Text(date,
               style: Theme.of(context).textTheme.subtitle,
               textAlign: TextAlign.center,
             ),
             new Text(date,
               style: Theme.of(context).textTheme.subtitle,
               textAlign: TextAlign.center,
             )
           ],)
           , SizedBox(height: 10.0,),
          new Image.network(image,fit: BoxFit.cover,),
            SizedBox(height: 10.0,),
            new Text(description,
              style: Theme.of(context).textTheme.subhead,
              textAlign: TextAlign.center,
            )

          ],
        ),
      ),
    );
  }
}