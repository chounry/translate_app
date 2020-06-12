import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

part 'chat_model.g.dart';

@HiveType(typeId: 1)
class ChatModel {
  static const String CHAT_ME_ICON = 'assets/khmer_flag.png';
  static const String CHAT_RECEPTION_ICON = 'assets/japan_english.png';

  @HiveField(0)
  final String text;
  //if isMe == true => the chat is the main language
  @HiveField(1)
  bool isMe;

  ChatModel({@required this.text, @required this.isMe});

  static List<ChatModel> getChats(int total) {
    bool isMe = true;
    List<ChatModel> chats = [];
    for (int i = 0; i < total; i++) {
      isMe = !isMe;
      ChatModel c = ChatModel(
        text:
            'Si bay nv? eklrtj lkjqw ltjq;lkejr;kqewj rlkjqe wlkrjl kwqjelrk jwelqkj r',
        isMe: isMe,
      );
      chats.add(c);
    }
    return chats;
  }

  String getIsMeIcon() {
    if (isMe) {
      return CHAT_ME_ICON;
    }
    return CHAT_RECEPTION_ICON;
  }
}
