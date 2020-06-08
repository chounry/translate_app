import 'package:flutter/cupertino.dart';

class ChatModel {
  static const String CHAT_ME_ICON = 'assets/khmer_flag.png';
  static const String CHAT_RECEPTION_ICON = 'assets/japan_english.png';

  final String text;
  final bool isMe;
  final String assetIcon;
  final String soundUrl;

  ChatModel(
      {@required this.text,
      @required this.isMe,
      this.assetIcon,
      @required this.soundUrl});

  static List<ChatModel> getChats(int total) {
    bool isMe = true;
    List<ChatModel> chats = [];
    for (int i = 0; i < total; i++) {
      isMe = !isMe;
      ChatModel c = ChatModel(
          text:
              'Si bay nv? eklrtj lkjqw ltjq;lkejr;kqewj rlkjqe wlkrjl kwqjelrk jwelqkj r',
          isMe: isMe,
          assetIcon: 'assets/khmer_flag.png',
          soundUrl: 'none');
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
