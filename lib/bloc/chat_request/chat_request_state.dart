import 'package:flutter/cupertino.dart';

class ChatRequestState {}

class OnTranslateSuccessState extends ChatRequestState {
  final String toTranslateText;
  final String translatedText;

  OnTranslateSuccessState(
      {@required this.toTranslateText, @required this.translatedText});
}

class OnTranslateFailState extends ChatRequestState {}
