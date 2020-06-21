import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import 'package:translateapp/model/abs_chat_model.dart';

part 'chat_data_model.g.dart';

@HiveType(typeId: 1)
class ChatDataModel implements AbsChatModel {
  static const String CHAT_ME_ICON = 'assets/england_flag.jpg';
  static const String CHAT_RECEPTION_ICON = 'assets/japan_flag.png';

  @HiveField(0)
  final String text;

  //if isMe == true => the chat is the main language
  @HiveField(1)
  bool isMe;
  @HiveField(2)
  final String icon;

  ChatDataModel(
      {@required this.text, @required this.isMe, @required this.icon});

//  static List<ChatModel> getChats(int total) {
//    bool isMe = true;
//    List<ChatModel> chats = [];
//    for (int i = 0; i < total; i++) {
//      isMe = !isMe;
//      ChatModel c = ChatModel(
//        text:
//            'Si bay nv? eklrtj lkjqw ltjq;lkejr;kqewj rlkjqe wlkrjl kwqjelrk jwelqkj r',
//        isMe: isMe,
//      );
//      chats.add(c);
//    }
//    return chats;
//  }
}
