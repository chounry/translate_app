import 'package:flutter/cupertino.dart';

class ChatRequestState {}

class OnTranslateSuccessState extends ChatRequestState {
  final String toTranslateText;
  final String translatedText;
  final bool isSwap;

  OnTranslateSuccessState(
      {@required this.toTranslateText,
      @required this.translatedText,
      @required this.isSwap});
}

class OnTranslateFailState extends ChatRequestState {}
