import 'package:flutter/cupertino.dart';
import 'package:translateapp/model/abs_chat_model.dart';
import 'package:translateapp/model/chat_data_model.dart';

class ChatLoaderState {}

class OnLoadChatState extends ChatLoaderState {
  final List<AbsChatModel> chats;
  final int currentOfflineIndex;
  final int allOfflineLength;
  final bool isSwap;

  OnLoadChatState({
    @required this.chats,
    @required this.currentOfflineIndex,
    @required this.allOfflineLength,
    @required this.isSwap,
  });
}
