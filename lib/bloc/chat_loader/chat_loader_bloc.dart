import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:translateapp/bloc/chat_loader/chat_loader_event.dart';
import 'package:translateapp/bloc/chat_loader/chat_loader_state.dart';
import 'package:translateapp/model/chat_model.dart';

class ChatLoaderBloc extends Bloc<ChatLoaderEvent, ChatLoaderState> {
  static const PAGE_SIZE = 10;
  int _currentOfflineLength = 0;
  List<ChatModel> _chatsToDisplay = [];
  List<ChatModel> _chatFromLocal = [];

  @override
  ChatLoaderState get initialState => ChatLoaderState();

  @override
  Stream<ChatLoaderState> mapEventToState(ChatLoaderEvent event) async* {
    if (event is OnChatLoadedEvent) {
      yield OnLoadChatState(
          allOfflineLength: _chatFromLocal.length,
          currentOfflineLength: _currentOfflineLength,
          chats: _chatsToDisplay);
    }

    if (event is OnLoadMoreEvent) {
      _loadChats();
    }

    if (event is OnAddNewMessageEvent) {
      _addMessageFromStart(event.getChats());
    }

    if (event is InitializeChatEvent) {
      _initializeHive();
    }
  }

  void _loadAllLocal() {
    Box box = Hive.box('translate_app');
    _chatFromLocal = (box.get('chat') as List)?.cast<ChatModel>();
    _chatFromLocal = _chatFromLocal == null ? [] : _chatFromLocal;
    _loadChats();
  }

  void _loadChats() async {
    Future.delayed(Duration(milliseconds: 500), () {
      List<ChatModel> chats = [];
      if (_currentOfflineLength < _chatFromLocal.length) {
        if ((_currentOfflineLength + PAGE_SIZE) > _chatFromLocal.length) {
          chats = _chatFromLocal
              .getRange(_currentOfflineLength, _chatFromLocal.length)
              .toList();
        } else {
          chats = _chatFromLocal
              .getRange(
                  _currentOfflineLength, _currentOfflineLength + PAGE_SIZE)
              .toList();
        }
        _chatsToDisplay.addAll(chats);
        _currentOfflineLength += PAGE_SIZE;
      }
      add(OnChatLoadedEvent());
    });
  }

  void _addMessageFromStart(List<ChatModel> chats) {
    print("_addMessageFromStart ${chats.length}");
    _chatsToDisplay.insertAll(0, chats);
    _chatFromLocal.insertAll(0, chats);
    _saveToLocal();
    add(OnChatLoadedEvent());
  }

  void _initializeHive() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocDir.path);
    Hive.registerAdapter(ChatModelAdapter());
    await Hive.openBox('translate_app');
    _loadAllLocal();
  }

  void _saveToLocal() {
    Box box = Hive.box('translate_app');
    box.put('chat', _chatFromLocal);
  }
}
