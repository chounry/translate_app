import 'package:flutter/cupertino.dart';
import 'package:translateapp/model/chat_data_model.dart';

class ChatLoaderEvent {}

class OnChatLoadedEvent extends ChatLoaderEvent {
  final bool isInputEnable;

  OnChatLoadedEvent(this.isInputEnable);
}

class OnLoadMoreEvent extends ChatLoaderEvent {}

class LoadAllLocalEvent extends ChatLoaderEvent {}

class OnSwapLanguageEvent extends ChatLoaderEvent {}

class OnRemoveChatLoadingEvent extends ChatLoaderEvent {}

class OnAddTranslatedMessageEvent extends ChatLoaderEvent {
  final ChatDataModel chatToDisplay;

  OnAddTranslatedMessageEvent(this.chatToDisplay);
}

class LoadToTranslateChatEvent extends ChatLoaderEvent {
  final ChatDataModel chat;

  LoadToTranslateChatEvent(this.chat);
}

class InitializeChatEvent extends ChatLoaderEvent {}
