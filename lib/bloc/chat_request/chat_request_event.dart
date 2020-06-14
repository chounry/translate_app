import 'package:flutter/cupertino.dart';
import 'package:translateapp/model/chat_model.dart';

class ChatRequestEvent {}

class OnSubmitMessageEvent extends ChatRequestEvent {
  final String text;

  OnSubmitMessageEvent(this.text);
}

class OnTranslateSuccessEvent extends ChatRequestEvent {
  final List<ChatModel> chatToDisplay;

  OnTranslateSuccessEvent(this.chatToDisplay);
}

class OnSwitchLanguageEvent extends ChatRequestEvent {}
