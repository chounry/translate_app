import 'package:flutter/cupertino.dart';
import 'package:translateapp/model/chat_model.dart';

class ChatLoaderEvent {}

class OnChatLoadedEvent extends ChatLoaderEvent {}

class OnChatLoadMoreEvent extends ChatLoaderEvent {}

class OnSwapLanguageEvent extends ChatLoaderEvent {}

class OnAddNewMessageEvent extends ChatLoaderEvent {
  final String toTranslateText;
  final String translatedText;

  OnAddNewMessageEvent(
      {@required this.toTranslateText, @required this.translatedText});

  List<ChatModel> getChats() {
    List<ChatModel> chats = [];
    ChatModel chat =
        ChatModel(isMe: false, text: translatedText, soundUrl: 'null');
    chats.add(chat);
    chat = ChatModel(isMe: true, text: toTranslateText, soundUrl: 'null');
    chats.add(chat);

    return chats;
  }
}
