import 'package:flutter/cupertino.dart';
import 'package:translateapp/model/chat_model.dart';

class ChatLoaderState {}

class OnLoadChatState extends ChatLoaderState {
  final List<ChatModel> chats;
  final int currentOfflineIndex;
  final int allOfflineLength;
  final bool isSwap;

  OnLoadChatState(
      {@required this.chats,
      @required this.currentOfflineIndex,
      @required this.allOfflineLength,
      @required this.isSwap});
}
