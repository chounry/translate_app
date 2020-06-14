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
  final List<ChatModel> chatToDisplay;

  OnAddNewMessageEvent(this.chatToDisplay);

//  List<ChatModel> getChats() {
//    List<ChatModel> chats = [];
//    String chatMeIcon =
//        !isSwap ? ChatModel.CHAT_ME_ICON : ChatModel.CHAT_RECEPTION_ICON;
//    String chatReceptionIcon =
//        isSwap ? ChatModel.CHAT_ME_ICON : ChatModel.CHAT_RECEPTION_ICON;
//
//    if (isSwap) {
//      ChatModel chat = ChatModel(
//          isMe: false,
//          text: toTranslateText,
//          icon: ChatModel.CHAT_RECEPTION_ICON);
//      chats.add(chat);
//      chat = ChatModel(
//          isMe: true, text: translatedText, icon: ChatModel.CHAT_ME_ICON);
//      chats.add(chat);
//    } else {
//      ChatModel chat = ChatModel(
//          isMe: false,
//          text: translatedText,
//          icon: ChatModel.CHAT_RECEPTION_ICON);
//      chats.add(chat);
//      chat = ChatModel(
//          isMe: true, text: toTranslateText, icon: ChatModel.CHAT_ME_ICON);
//      chats.add(chat);
//    }

//    ChatModel chat =
//        ChatModel(isMe: false, text: translatedText, icon: chatReceptionIcon);
//    chats.add(chat);
//    chat = ChatModel(isMe: true, text: toTranslateText, icon: chatMeIcon);
//    chats.add(chat);

//  return
//
//  chats

//  ;
//}
}

class InitializeChatEvent extends ChatLoaderEvent {}
