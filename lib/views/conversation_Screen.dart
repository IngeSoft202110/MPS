import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mps/helpfunctions/constant.dart';
import 'package:mps/services/auth.dart';
import 'package:mps/views/widget_chat.dart';
import 'dart:io';

class ConversationScreen extends StatefulWidget {
  
  final String chatRoomId;
  ConversationScreen (this.chatRoomId);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {

  TextEditingController menssageController = new TextEditingController();

  Stream<QuerySnapshot> chatMenssagesStream;
  
  Widget ChatMenssageList(){

    return StreamBuilder(
      stream: chatMenssagesStream,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index){
            return MenssageTile(
                menssage: snapshot.data.docs[index].data["message"],
                isSendByMe: Constant.myName == snapshot.data.docs[index].data["sendBy"],
            );
          }) : Container();
      },
    );
  }

  sendMessage(){

    if(menssageController.text.isNotEmpty){
      Map<String, dynamic> mensageMap = {
      "mensaje" : menssageController.text,
      "sendBy" : Constant.myName,
      "time" : DateTime.now().millisecondsSinceEpoch,  
      };

      AuthMethods().addConversationMenssages(widget.chatRoomId, mensageMap);
      
      setState(() {
       menssageController.text = "";
      });
    }

  }

  @override
  void initState() {
    AuthMethods().getConversationMenssages(widget.chatRoomId).then((value){
      setState(() {
        chatMenssagesStream = value;
      }); 
    });
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarMain(context),
        body: Container(
          child: Stack(
            children: [
              ChatMenssageList(),
              Container(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Colors.black,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextField(
                        controller: menssageController,
                        style: TextStyle(color: Colors.amber),
                        decoration: InputDecoration(
                            hintText: "Mensaje ....",
                            hintStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              ),
                            border: InputBorder.none
                            ),
                      )),
                      SizedBox(width: 16,),
                      GestureDetector(
                        onTap: () {
                          sendMessage();
                        },
                        child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  const Color(0x00000000),
                                  const Color(0x00000000)
                                ],
                                begin: FractionalOffset.topLeft,
                                  end: FractionalOffset.bottomRight
                                ),
                                borderRadius: BorderRadius.circular(40)),
                            padding: EdgeInsets.all(12),
                            child:
                                Image.asset("asset/send.png")),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }
}

class MenssageTile extends StatelessWidget {
  final String menssage;
  final bool isSendByMe; 
  MenssageTile({this.menssage, this.isSendByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 8,
          bottom: 8,
          left: isSendByMe ? 0 : 24,
          right: isSendByMe ? 24 : 0),
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: isSendByMe
            ? EdgeInsets.only(left: 30)
            : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(
            top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: isSendByMe ? BorderRadius.only(
                topLeft: Radius.circular(23),
                topRight: Radius.circular(23),
                bottomLeft: Radius.circular(23)
            ) :
            BorderRadius.only(
        topLeft: Radius.circular(23),
          topRight: Radius.circular(23),
          bottomRight: Radius.circular(23)),
            gradient: LinearGradient(
              colors: isSendByMe ? [
                const Color(0xff007EF4),
                const Color(0xff2A75BC)
              ]
                  : [
                const Color(0x1AFFFFFF),
                const Color(0x1AFFFFFF)
              ],
            )
        ),
        child: Text(menssage,
            textAlign: TextAlign.start,
            style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontFamily: 'OverpassRegular',
            fontWeight: FontWeight.w300)),
      ),
    );
  }
}
