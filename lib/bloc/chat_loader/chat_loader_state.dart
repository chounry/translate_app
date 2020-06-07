import 'package:flutter/cupertino.dart';
import 'package:translateapp/model/chat_model.dart';

class ChatLoaderState {}

class OnLoadChatState extends ChatLoaderState {
  final List<ChatModel> chats;
  final int currentOfflineLength;
  final int allOfflineLength;

  OnLoadChatState(
      {@required this.chats,
      @required this.currentOfflineLength,
      @required this.allOfflineLength});
}
