import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mps/services/database.dart';
import 'package:mps/views/widget_chat.dart';
import 'package:mps/services/auth.dart';
import '../services/database.dart';


class Search_people extends StatefulWidget {
  @override
  _Search_peopleState createState() => _Search_peopleState();
}

class _Search_peopleState extends State<Search_people> {
  
  //DatabaseMethods databaseMethods = new DatabaseMethods();


  TextEditingController searchTextEditingController = new TextEditingController();
  QuerySnapshot searchSnapshot;
  
  
  initiateSearch(){
      AuthMethods()
      .getUserByname(searchTextEditingController.text)
      .then((val){
        searchSnapshot = val;
      });
  }

  Widget searchList(){
    return ListView.builder(
      itemCount: searchSnapshot.docs.length,
      itemBuilder: (context, index){
        return SearchTile(
          //userName: searchSnapshot.docs[index].get("name")
          //userEmail: searchSnapshot.docs[index].get("email"),
        );
      }
    );
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
                      style: TextStyle(
                          color: Colors.white54),
                      decoration: InputDecoration(
                        hintText: "Busca el Username del usuario ...",
                        hintStyle: TextStyle(
                          color: Colors.white54
                        ),
                        border: InputBorder.none
                      ),
                    )
                  ),
                  GestureDetector(
                    onTap: (){
                      initiateSearch();
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0x36FFFFFF),
                            const Color(0x0FFFFFFF)
                          ]
                        ),
                        borderRadius: BorderRadius.circular(13)
                      ),
                      padding: EdgeInsets.all(10),
                      child: Image.asset("asset/images/search_white.png")),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SearchTile extends StatelessWidget {

  //final String userName;
  //final String userEmail;
  //SearchTitle({this.userName, this.userEmail});  
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Column(
            children: [
              //Text(userName, style: simpleTextStyle(), ),
              //Text(userEmail, style: simpleTextStyle(), )
            ],
          ),
          Spacer(),
          Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(30)
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text("Mensaje"),
          )
        ],
      ),
    );
  }
}