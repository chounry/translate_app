import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:translateapp/bloc/chat_request/chat_request_event.dart';
import 'package:translateapp/model/chat_model.dart';
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
      _translate(event.text);
    }

    if (event is OnTranslateSuccessEvent) {
      yield OnTranslateSuccessState(event.chatToDisplay);
    }

    if (event is OnSwitchLanguageEvent) {
      _isSwap = !_isSwap;
      _switchLanguage();
    }
  }

  void _translate(String toTranslate) async {
    _translator.baseUrl = "https://translate.google.cn/translate_a/single";
    _translator.translate(toTranslate, from: _from, to: _to).then((value) {
      add(OnTranslateSuccessEvent(_getChatsToDisplay(value, toTranslate)));
      _saveToLocal(_getChatsToSave(value, toTranslate));
    }).catchError((onError) {
      print("TRANSLATE ERROR :: $onError");
    });
  }

  List<ChatModel> _getChatsToSave(String translated, String toTranslate) {
    List<ChatModel> chats = [];

    if (_isSwap) {
      ChatModel chat = ChatModel(
          isMe: false, text: toTranslate, icon: ChatModel.CHAT_RECEPTION_ICON);
      chats.add(chat);
      chat =
          ChatModel(isMe: true, text: translated, icon: ChatModel.CHAT_ME_ICON);
      chats.add(chat);
    } else {
      ChatModel chat = ChatModel(
          isMe: false, text: translated, icon: ChatModel.CHAT_RECEPTION_ICON);
      chats.add(chat);
      chat = ChatModel(
          isMe: true, text: toTranslate, icon: ChatModel.CHAT_ME_ICON);
      chats.add(chat);
    }

    return chats;
  }

  List<ChatModel> _getChatsToDisplay(String translated, String toTranslate) {
    List<ChatModel> chats = [];
    String chatMeIcon =
        _isSwap ? ChatModel.CHAT_RECEPTION_ICON : ChatModel.CHAT_ME_ICON;
    String chatReceptionIcon =
        _isSwap ? ChatModel.CHAT_ME_ICON : ChatModel.CHAT_RECEPTION_ICON;

    ChatModel chatReception =
        ChatModel(text: translated, isMe: false, icon: chatReceptionIcon);
    chats.add(chatReception);
    ChatModel chatMe =
        ChatModel(text: toTranslate, isMe: true, icon: chatMeIcon);
    chats.add(chatMe);
    return chats;
  }

  void _saveToLocal(List<ChatModel> chatToSave) async {
    Box box = await Hive.openBox('translate_app');
    List<ChatModel> chatFromLocal =
        (box.get('chat') as List)?.cast<ChatModel>();
    chatFromLocal = chatFromLocal ?? [];
    chatFromLocal.insertAll(0, chatToSave);
    await box.put('chat', chatFromLocal);

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
