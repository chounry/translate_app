import 'package:flutter/cupertino.dart';
import 'package:translateapp/model/chat_model.dart';

class ChatLoaderEvent {}

class OnChatLoadedEvent extends ChatLoaderEvent {}

class OnLoadMoreEvent extends ChatLoaderEvent {}

class LoadAllLocalEvent extends ChatLoaderEvent {}

class OnSwapLanguageEvent extends ChatLoaderEvent {}

class OnAddNewMessageEvent extends ChatLoaderEvent {
  final String toTranslateText;
  final String translatedText;

  OnAddNewMessageEvent(
      {@required this.toTranslateText, @required this.translatedText});

  List<ChatModel> getChats() {
    List<ChatModel> chats = [];
    ChatModel chat = ChatModel(isMe: false, text: translatedText);
    chats.add(chat);
    chat = ChatModel(isMe: true, text: toTranslateText);
    chats.add(chat);

    return chats;
  }
}

class InitializeChatEvent extends ChatLoaderEvent {}
