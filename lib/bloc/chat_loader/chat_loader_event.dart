import 'package:flutter/cupertino.dart';
import 'package:translateapp/model/chat_data_model.dart';

class ChatLoaderEvent {}

class OnChatLoadedEvent extends ChatLoaderEvent {}

class OnLoadMoreEvent extends ChatLoaderEvent {}

class LoadAllLocalEvent extends ChatLoaderEvent {}

class OnSwapLanguageEvent extends ChatLoaderEvent {}

class OnSpeakClickEvent extends ChatLoaderEvent {
  final int index;

  OnSpeakClickEvent(this.index);
}

class OnAddTranslatedMessageEvent extends ChatLoaderEvent {
  final ChatDataModel chatToDisplay;

  OnAddTranslatedMessageEvent(this.chatToDisplay);
}

class LoadToTranslateChatEvent extends ChatLoaderEvent {
  final ChatDataModel chat;

  LoadToTranslateChatEvent(this.chat);
}

class InitializeChatEvent extends ChatLoaderEvent {}
