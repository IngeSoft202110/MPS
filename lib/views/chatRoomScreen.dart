import 'package:flutter/material.dart';
import 'package:mps/views/mainpageuser.dart';
import 'package:mps/views/search_people.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  
  MainPageUser mainPageUser = new MainPageUser();

  @override
  Widget build(BuildContext context) {  
    return Scaffold(
      appBar: AppBar(
        title: Image.asset("asset/images/logo_chat.png",
        height: 50,),
        actions: [
          GestureDetector(  
            onTap: (){
              Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (context) => MainPageUser()
                ));
            },
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.exit_to_app)) ,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => Search_people()
            )); 
        },
      ),
    );
  }
}
