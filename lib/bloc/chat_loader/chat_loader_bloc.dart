import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:translateapp/bloc/chat_loader/chat_loader_event.dart';
import 'package:translateapp/bloc/chat_loader/chat_loader_state.dart';
import 'package:translateapp/model/chat_model.dart';

class ChatLoaderBloc extends Bloc<ChatLoaderEvent, ChatLoaderState> {
  static const PAGE_SIZE = 10;
  int _currentOfflineIndex = 0;
  List<ChatModel> _chatsToDisplay = [];
  List<ChatModel> _chatFromLocal = [];
  bool _isSwap = false;

  @override
  ChatLoaderState get initialState => ChatLoaderState();

  @override
  Stream<ChatLoaderState> mapEventToState(ChatLoaderEvent event) async* {
    if (event is OnChatLoadedEvent) {
      yield OnLoadChatState(
          allOfflineLength: _chatFromLocal.length,
          currentOfflineIndex: _currentOfflineIndex,
          chats: _chatsToDisplay,
          isSwap: _isSwap);
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

    if (event is OnSwapLanguageEvent) {
      yield ChatLoaderState();
      _isSwap = !_isSwap;
      _reset();
    }
  }

  void _reset() async {
    if (Hive.isBoxOpen('translate_app')) {
      // this prevent getting the old edited chat
      await Hive.close();
    }
    _chatsToDisplay = [];
    _currentOfflineIndex = 0;
    _loadAllLocal();
  }

  void _loadAllLocal() async {
    Box box = await Hive.openBox('translate_app');
    _chatFromLocal = (box.get('chat') as List)?.cast<ChatModel>();
    _chatFromLocal = _chatFromLocal ?? [];

    _loadChats();
  }

  void _loadChats() async {
    Future.delayed(Duration(milliseconds: 500), () {
      List<ChatModel> chats = [];
      if (_currentOfflineIndex < _chatFromLocal.length) {
        if ((_currentOfflineIndex + PAGE_SIZE) > _chatFromLocal.length) {
          chats = _chatFromLocal
              .getRange(_currentOfflineIndex, _chatFromLocal.length)
              .toList();
        } else {
          chats = _chatFromLocal
              .getRange(_currentOfflineIndex, _currentOfflineIndex + PAGE_SIZE)
              .toList();
        }
        if (_isSwap) {
          chats = chats.map((chat) {
            chat.isMe = !chat.isMe;
            return chat;
          }).toList();
          chats = _switchChat(chats);
        }
        _chatsToDisplay.addAll(chats);
        _currentOfflineIndex += PAGE_SIZE;
      }
      add(OnChatLoadedEvent());
    });
  }

  List<ChatModel> _switchChat(List<ChatModel> chats) {
    List<ChatModel> switchedChats = [];
    for (int i = 0; i < chats.length; i += 2) {
      ChatModel firstChat = chats[i];
      ChatModel secondChat = chats[i + 1];

      switchedChats.insert(switchedChats.length, secondChat);
      switchedChats.insert(switchedChats.length, firstChat);
    }

    return switchedChats;
  }

  void _addMessageFromStart(List<ChatModel> chats) {
    _chatsToDisplay.insertAll(0, chats);
    _chatFromLocal.insertAll(0, chats);
    _saveToLocal();
    _currentOfflineIndex += 2;
    add(OnChatLoadedEvent());
  }

  void _initializeHive() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocDir.path);
    Hive.registerAdapter(ChatModelAdapter());
    _loadAllLocal();
  }

  void _saveToLocal() async {
    Box box = await Hive.openBox('translate_app');
    box.put('chat', _chatFromLocal);
  }
}
