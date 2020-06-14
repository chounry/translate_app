import 'package:flutter/cupertino.dart';
import 'package:translateapp/model/chat_model.dart';

class ChatLoaderEvent {}

class OnChatLoadedEvent extends ChatLoaderEvent {}

class OnLoadMoreEvent extends ChatLoaderEvent {}

class LoadAllLocalEvent extends ChatLoaderEvent {}

class OnSwapLanguageEvent extends ChatLoaderEvent {}

class OnSpeakClickEvent extends ChatLoaderEvent {
  final int index;

  OnSpeakClickEvent(this.index);
}

class OnAddNewMessageEvent extends ChatLoaderEvent {
  final String toTranslateText;
  final String translatedText;
  final isSwap;

  OnAddNewMessageEvent(
      {@required this.toTranslateText,
      @required this.translatedText,
      @required this.isSwap});

  List<ChatModel> getChats() {
    List<ChatModel> chats = [];
    String chatMeIcon =
        !isSwap ? ChatModel.CHAT_ME_ICON : ChatModel.CHAT_RECEPTION_ICON;
    String chatReceptionIcon =
        isSwap ? ChatModel.CHAT_ME_ICON : ChatModel.CHAT_RECEPTION_ICON;

    ChatModel chat =
        ChatModel(isMe: false, text: translatedText, icon: chatReceptionIcon);
    chats.add(chat);
    chat = ChatModel(isMe: true, text: toTranslateText, icon: chatMeIcon);
    chats.add(chat);

    return chats;
  }
}

class InitializeChatEvent extends ChatLoaderEvent {}
