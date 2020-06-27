import 'package:flutter/cupertino.dart';
import 'package:translateapp/model/abs_chat_model.dart';

class ChatLoaderState {}

class OnLoadChatState extends ChatLoaderState {
  final List<AbsChatModel> chats;
  final int currentOfflineIndex;
  final int allOfflineLength;
  final String inputHintText;
  final bool isInputEnable;
  final bool isSwap;

  OnLoadChatState(
      {@required this.chats,
      @required this.currentOfflineIndex,
      @required this.allOfflineLength,
      @required this.isSwap,
      @required this.inputHintText,
      this.isInputEnable = true});

  String getSwitchImage() {
    return isSwap ? 'assets/japan_english.png' : 'assets/english_japan.png';
  }
}
