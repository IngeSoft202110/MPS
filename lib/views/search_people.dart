import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mps/helpfunctions/constant.dart';
import 'package:mps/services/database.dart';
import 'package:mps/views/conversation_Screen.dart';
import 'package:mps/views/widget_chat.dart';
import 'package:mps/services/auth.dart';
import '../services/database.dart';


class Search_people extends StatefulWidget {
  @override
  _Search_peopleState createState() => _Search_peopleState();
}


class _Search_peopleState extends State<Search_people> {
  
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController searchTextEditingController = new TextEditingController();
  QuerySnapshot searchSnapshot;

  bool isLoading = false;
  bool haveUserSearched = false;


  initiateSearch() async {
    AuthMethods().getUserByname(searchTextEditingController.text)
    .then((val){
      searchSnapshot = val;
    });
  }

  Widget searchL() {
   return haveUserSearched ? ListView.builder(
      shrinkWrap: true,
      itemCount: searchSnapshot.docs.length,
        itemBuilder: (context, index){
        return userTile(
          searchSnapshot.docs[index].get("userName"),
          searchSnapshot.docs[index].get("userName"),
        );
        }) : Container();
  }

  //chatroom
  SednMenssaje(String userName){

    if(userName != Constant.myName){
    List<String> users = [Constant.myName,userName];

    String chatRoomId = getChatRoomId(Constant.myName, userName);

    Map<String, dynamic> chatRoom = {
      "users": users,
      "chatRoomId" : chatRoomId,
    };

    AuthMethods().addChatRoom(chatRoom, chatRoomId);

    Navigator.push(context, MaterialPageRoute(
      builder: (context) => ConversationScreen(
        chatRoomId,
      )
    ));
    }
  }


  Widget userTile(String userName, String userEmail){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: simpleTextStyle(),
              ),
              Text(
                userEmail,
                style: simpleTextStyle(),
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: (){
              SednMenssaje(userName);
            },
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 12,vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.blue, 
                  borderRadius: BorderRadius.circular(24)
                  ),
              child: Text("Mensaje", style: simpleTextStyle(),),
            ),
          )
        ],
      ),
    ) ;
  
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children: [
            Container(
              color: Color(0x54FFFFFF),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: searchTextEditingController,
                    style: TextStyle(color: Colors.white54),
                    decoration: InputDecoration(
                        hintText: "Busca el Username del usuario ...",
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none),
                  )),
                  GestureDetector(
                    onTap: () {
                      initiateSearch();
                    },
                    child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              const Color(0x36FFFFFF),
                              const Color(0x0FFFFFFF)
                            ]),
                            borderRadius: BorderRadius.circular(40)
                            ),
                        padding: EdgeInsets.all(12),
                        child: Image.asset("asset/images/search_white.png", height: 25, width: 25,)),
                  )
                ],
              ),
            ),
            searchL()
          ],
        ),
      ),
    );
  }
}

