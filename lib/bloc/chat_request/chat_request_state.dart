import 'package:translateapp/model/chat_model.dart';

class ChatRequestState {}

class OnTranslateSuccessState extends ChatRequestState {
  final List<ChatModel> chatsToDisplay;

  OnTranslateSuccessState(this.chatsToDisplay);
}

class OnTranslateFailState extends ChatRequestState {}
