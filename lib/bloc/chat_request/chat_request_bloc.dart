import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translateapp/bloc/chat_request/chat_request_event.dart';
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
      yield OnTranslateSuccessState(
          translatedText: event.translatedText,
          toTranslateText: event.toTranslateText,
          isSwap: _isSwap);
    }

    if (event is OnSwitchLanguageEvent) {
      _isSwap = !_isSwap;
      _switchLanguage();
    }
  }

  void _translate(String toTranslate) async {
    _translator.baseUrl = "https://translate.google.cn/translate_a/single";
    _translator.translate(toTranslate, from: _from, to: _to).then((value) {
      add(OnTranslateSuccessEvent(
          translatedText: value, toTranslateText: toTranslate));
    }).catchError((onError) {
      print("TRANSLATE ERROR :: $onError");
    });
  }

  void _switchLanguage() {
    String tmp = _from;
    _from = _to;
    _to = tmp;
  }
}
