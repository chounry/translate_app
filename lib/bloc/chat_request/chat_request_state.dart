import 'package:translateapp/model/chat_data_model.dart';
import 'package:translateapp/model/dialog_error_model.dart';

class ChatRequestState {}

class OnTranslateSuccessState extends ChatRequestState {
  final ChatDataModel chat;

  OnTranslateSuccessState(this.chat);
}

class OnLoadToTranslateTextState extends ChatRequestState {
  final ChatDataModel chat;

  OnLoadToTranslateTextState(this.chat);
}

class OnTranslateFailState extends ChatRequestState {
  final DialogErrorModel errorMessage;

  OnTranslateFailState(this.errorMessage);
}
