import 'package:flutter/cupertino.dart';

class ChatRequestEvent {}

class OnSubmitMessageEvent extends ChatRequestEvent {
  final String text;

  OnSubmitMessageEvent(this.text);
}

class OnTranslateSuccessEvent extends ChatRequestEvent{
  final String toTranslateText;
  final String translatedText;

  OnTranslateSuccessEvent({@required this.translatedText,@required this.toTranslateText});
}
