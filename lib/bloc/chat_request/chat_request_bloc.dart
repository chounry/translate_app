import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:translateapp/bloc/chat_request/chat_request_event.dart';
import 'package:translateapp/model/chat_data_model.dart';
import 'package:translateapp/model/dialog_error_model.dart';
import 'package:translator/translator.dart';

import 'chat_request_state.dart';

class ChatRequestBloc extends Bloc<ChatRequestEvent, ChatRequestState> {
  GoogleTranslator _translator = new GoogleTranslator();
  String _from = 'en';
  String _to = 'ja';
  bool _isSwap = false;

  @override
  ChatRequestState get initialState => ChatRequestState();

  @override
  Stream<ChatRequestState> mapEventToState(ChatRequestEvent event) async* {
    if (event is OnSubmitMessageEvent) {
      _saveEachToLocal(_getToTranslateChatToSave(event.text));
      yield OnLoadToTranslateTextState(_getChatMeToDisplay(event.text));
      await Future.delayed(Duration(seconds: 2));
      _translate(event.text);
    }

    if (event is OnTranslateSuccessEvent) {
      yield OnTranslateSuccessState(event.chatToDisplay);
    }

    if (event is OnSwitchLanguageEvent) {
      _isSwap = !_isSwap;
      _switchLanguage();
    }

    if (event is OnTranslateFailEvent) {
      _removeOneLastChat();
      yield OnTranslateFailState(event.errorMessage);
    }
  }

  void _translate(String toTranslate) async {
    _translator.baseUrl = "https://translate.google.cn/translate_a/single";
    _translator.translate(toTranslate, from: _from, to: _to).then((value) {
      add(OnTranslateSuccessEvent(_getChatReceptionToDisplay(value)));
      _saveEachToLocal(_getTranslatedChatToSave(value));
    }).catchError((onError) {
      DialogErrorModel errorMessage = DialogErrorModel('Something Went Wrong',
          'Something wrong with the connection between server and the device.');
      add(OnTranslateFailEvent(errorMessage));
      print("TRANSLATE ERROR :: $onError");
    });
  }

  ChatDataModel _getToTranslateChatToSave(String text) {
    ChatDataModel chat;

    if (_isSwap) {
      chat = ChatDataModel(
          isMe: false, text: text, icon: ChatDataModel.CHAT_RECEPTION_ICON);
    } else {
      chat = ChatDataModel(
          isMe: true, text: text, icon: ChatDataModel.CHAT_ME_ICON);
    }

    return chat;
  }

  ChatDataModel _getTranslatedChatToSave(String text) {
    ChatDataModel chat;

    if (!_isSwap) {
      chat = ChatDataModel(
          isMe: false, text: text, icon: ChatDataModel.CHAT_RECEPTION_ICON);
    } else {
      chat = ChatDataModel(
          isMe: true, text: text, icon: ChatDataModel.CHAT_ME_ICON);
    }

    return chat;
  }

  ChatDataModel _getChatMeToDisplay(String text) {
    String chatIcon = _isSwap
        ? ChatDataModel.CHAT_RECEPTION_ICON
        : ChatDataModel.CHAT_ME_ICON;
    ChatDataModel chat = ChatDataModel(text: text, isMe: true, icon: chatIcon);
    return chat;
  }

  ChatDataModel _getChatReceptionToDisplay(String text) {
    String chatIcon = _isSwap
        ? ChatDataModel.CHAT_ME_ICON
        : ChatDataModel.CHAT_RECEPTION_ICON;
    ChatDataModel chat = ChatDataModel(text: text, isMe: false, icon: chatIcon);
    return chat;
  }

  void _saveEachToLocal(ChatDataModel chatToSave) async {
//    we always save the the translated('ja') txt at the index 1,
    Box box = await Hive.openBox('translate_app');
    List<ChatDataModel> chatFromLocal =
        (box.get('chat') as List)?.cast<ChatDataModel>();
    chatFromLocal = chatFromLocal ?? [];
    bool needChangeSaveIndex = _isSwap && chatToSave.isMe;
    if (needChangeSaveIndex) {
      chatFromLocal.insert(1, chatToSave);
    } else {
      chatFromLocal.insert(0, chatToSave);
    }
    await box.put('chat', chatFromLocal);

    if (Hive.isBoxOpen('translate_app')) {
      await Hive.close();
    }
  }

  void _removeOneLastChat() async {
    Box box = await Hive.openBox('translate_app');

    List<ChatDataModel> chatFromLocal =
        (box.get('chat') as List)?.cast<ChatDataModel>();
    chatFromLocal = chatFromLocal ?? [];
    chatFromLocal.removeAt(0);
    box.put("chat", chatFromLocal);

    if (Hive.isBoxOpen('translate_app')) {
      await Hive.close();
    }
  }

  void _switchLanguage() {
    String tmp = _from;
    _from = _to;
    _to = tmp;
  }
}
