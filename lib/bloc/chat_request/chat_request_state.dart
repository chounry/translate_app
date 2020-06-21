import 'package:translateapp/model/chat_data_model.dart';

class ChatRequestState {}

class OnTranslateSuccessState extends ChatRequestState {
  final ChatDataModel chat;

  OnTranslateSuccessState(this.chat);
}

class OnLoadToTranslateTextState extends ChatRequestState {
  final ChatDataModel chat;

  OnLoadToTranslateTextState(this.chat);
}

class OnTranslateFailState extends ChatRequestState {}
