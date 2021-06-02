import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:mps/helpfunctions/constant.dart';
import 'package:mps/helpfunctions/sharedpref_help.dart';
import 'package:mps/services/auth.dart';
import 'package:mps/views/conversation_Screen.dart';
import 'package:mps/views/mainpageuser.dart';
import 'package:mps/views/search_people.dart';
import 'package:mps/views/widget_chat.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  Stream chatRoomsStream;

  Widget ChatRoomList(){
      return StreamBuilder(
        stream: chatRoomsStream,
        builder: (context, snapshot){
          return snapshot.hasData ? ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index){
              return ChatRoomsTile(
                snapshot.data.documents[index].data["chatroomId"]
                .toString().replaceAll("_", "")
                .replaceAll(Constant.myName, ""),
                snapshot.data.documents[index].data["chatroomId"]
              );
            }
          ) : Container();
        },
      );
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();  
  }

  getUserInfo() async{
    Constant.myName = await SharedPreferenceHelp().getUserName();
    AuthMethods().getChatRooms(Constant.myName).then((snapshots){
      setState(() {
        chatRoomsStream = snapshots;
        print("we got the data + ${chatRoomsStream.toString()} this is name  ${Constant.myName}");
      });
    });

  }

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
      body: ChatRoomList(),
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

class ChatRoomsTile extends StatelessWidget {

  final String userName;
  final String chatRoomId; 
  ChatRoomsTile(this.userName, this.chatRoomId);

  @override
  Widget build(BuildContext context) {
    return GestureDetector( 
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => ConversationScreen(chatRoomId)
        ));
      },
    child: Container(
      color: Colors.black26,
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40 ,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(40)
            ),
            child: Text("${userName.substring(0,1).toUpperCase()}",
            style: mediumTextStyle(),),
          ),
          SizedBox(width: 8,),
          Text(userName, style: mediumTextStyle(),)
        ],
      ),
    ),
  );
}
}
