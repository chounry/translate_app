import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translateapp/bloc/chat_item_copy/chat_item_copy_event.dart';
import 'package:translateapp/bloc/chat_item_copy/chat_item_copy_state.dart';

class ChatItemCopyBloc extends Bloc<ChatItemCopyEvent, ChatItemCopyState> {
  String _text;


  ChatItemCopyBloc(this._text);

  @override
  ChatItemCopyState get initialState => ChatItemCopyState();

  @override
  Stream<ChatItemCopyState> mapEventToState(ChatItemCopyEvent event) async* {
    if (event is OnCopyClickEvent) {
      Clipboard.setData(new ClipboardData(text: _text));
      yield OnDisplayCopiedTextState();
      await Future.delayed(Duration(seconds: 1));
      yield OnDisplayCopyIconState();
    }
  }
}
