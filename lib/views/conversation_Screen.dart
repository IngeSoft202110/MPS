import 'dart:html';

import 'package:flutter/material.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:mps/helpfunctions/constant.dart';
import 'package:mps/services/auth.dart';
import 'package:mps/views/widget_chat.dart';

class ConversationScreen extends StatefulWidget {
  
  String chatRoomId;
  ConversationScreen (this.chatRoomId);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {

  TextEditingController menssageController = new TextEditingController();

  Stream chatMenssagesStream;
  
  Widget ChatMenssageList(){

    return StreamBuilder(
      stream: chatMenssagesStream,
      builder: (context, snapshot){
        return snapshot.hasData ? ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index){
            return MenssageTile(snapshot.data.documents[index].data["menssage"],
              snapshot.data.documents[index].data["sendBy"] == Constant.myName);
          }) : Container();
      },
    );
  }

  sendMessage(){

    if(menssageController.text.isNotEmpty){
      Map<String, dynamic> mensageMap = {
      "mensaje" : menssageController.text,
      "sendBy" : Constant.myName
      //S"time" : DateTime.now().millisecondsSinceEpoch,
      };
      AuthMethods().addConversationMenssages(widget.chatRoomId, mensageMap);
      menssageController.text = "";
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
                  color: Color(0x54FFFFFF),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextField(
                        controller: menssageController,
                        style: TextStyle(color: Colors.white54),
                        decoration: InputDecoration(
                            hintText: "Mensaje ....",
                            hintStyle: TextStyle(color: Colors.white54),
                            border: InputBorder.none),
                      )),
                      GestureDetector(
                        onTap: () {
                          sendMessage();
                        },
                        child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  const Color(0x36FFFFFF),
                                  const Color(0x0FFFFFFF)
                                ]),
                                borderRadius: BorderRadius.circular(13)),
                            padding: EdgeInsets.all(10),
                            child:
                                Image.asset("asset/images/send.png")),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class MenssageTile extends StatelessWidget {
  final String menssage;
  final bool isSendByMe; 
  MenssageTile(this.menssage, this.isSendByMe);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: isSendByMe ? 0:24, right: isSendByMe ? 24:0),
      margin: EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child:Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isSendByMe ? [
            const Color(0xff007EF4),
            const Color(0xff2A75BC)
          ]
            : [
              const Color(0x1FFFFFFF),
              const Color(0x1FFFFFFF)
            ],
        ),
        borderRadius: isSendByMe ?
            BorderRadius.only (
              topLeft: Radius.circular(23),
              topRight: Radius.circular(23),
              bottomLeft: Radius.circular(23),
            ) :
        BorderRadius.only(
              topLeft: Radius.circular(23),
              topRight: Radius.circular(23),
              bottomLeft: Radius.circular(23),
        )
      ), 
      child: Text(menssage, style: TextStyle(
        color: Colors.white,
        fontSize: 17
        )
      ),),
    );
  }
}
