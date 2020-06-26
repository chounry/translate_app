import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:translateapp/bloc/chat_loader/chat_loader_event.dart';
import 'package:translateapp/bloc/chat_loader/chat_loader_state.dart';
import 'package:translateapp/config/config.dart';
import 'package:translateapp/model/abs_chat_model.dart';
import 'package:translateapp/model/chat_data_model.dart';
import 'package:translateapp/model/chat_loading_model.dart';

enum TtsState { playing, stopped }

class ChatLoaderBloc extends Bloc<ChatLoaderEvent, ChatLoaderState> {
  static const PAGE_SIZE = 10;
  int _currentOfflineIndex = 0;
  List<AbsChatModel> _chatsToDisplay = [];
  List<ChatDataModel> _chatFromLocal = [];
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
          isSwap: _isSwap,
          inputHintText: _isSwap
              ? Config.INPUT_HINT_TRANSLATED
              : Config.INPUT_HINT_TO_TRANSLATE,
          isInputEnable: event.isInputEnable);
    }

    if (event is OnLoadMoreEvent) {
      _loadChats();
    }

    if (event is OnRemoveChatLoadingEvent) {
      _removeChatLoading();
      add(OnChatLoadedEvent(true));
    }

    if (event is OnAddTranslatedMessageEvent) {
      _removeChatLoading();
      _addMessageFromStart(event.chatToDisplay);
      add(OnChatLoadedEvent(true));
    }

    if (event is LoadToTranslateChatEvent) {
      _addMessageFromStart(event.chat);
      _addMessageFromStart(ChatLoadingModel());
      add(OnChatLoadedEvent(false));
    }

    if (event is InitializeChatEvent) {
      _initializeHive();
    }

    if (event is OnSwapLanguageEvent) {
      yield ChatLoaderState();
      _isSwap = !_isSwap;
      _reset();
    }

    if (event is RemoveOneLatestChatEvent) {
      _removeLatestOneFromDisplay();
      add(OnChatLoadedEvent(true));
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
    _chatFromLocal = (box.get('chat') as List)?.cast<ChatDataModel>();
    _chatFromLocal = _chatFromLocal ?? [];
    bool shouldSaveInitialChat = _chatFromLocal.length == 0;
    if (shouldSaveInitialChat) {
      await _createInitialChats();
    }
    if (Hive.isBoxOpen('translate_app')) {
      // this prevent getting the old edited chat
      await Hive.close();
    }
    _loadChats();
  }

  void _removeLatestOneFromDisplay() {
    _chatsToDisplay.removeAt(0);
  }

  Future<void> _createInitialChats() async {
    Box box = await Hive.openBox('translate_app');
    List<ChatDataModel> chatsToSave = [];
    ChatDataModel initialChat = ChatDataModel(
        isMe: false, icon: ChatDataModel.CHAT_DEFAULT_ICON, isDefault: true);
    chatsToSave.add(initialChat);
    await box.put('chat', chatsToSave);
    _chatFromLocal = chatsToSave;

    if (Hive.isBoxOpen('translate_app')) {
      // this prevent getting the old edited chat
      await Hive.close();
    }
  }

  void _loadChats() async {
    Future.delayed(Duration(milliseconds: 500), () {
      List<ChatDataModel> chats = [];
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
            chat.isMe = chat.isDefault ? chat.isMe : !chat.isMe;
            return chat;
          }).toList();
          chats = _switchChat(chats);
        }
        _chatsToDisplay.addAll(chats);
        _currentOfflineIndex += PAGE_SIZE;
      }
      add(OnChatLoadedEvent(true));
    });
  }

  List<ChatDataModel> _switchChat(List<ChatDataModel> chats) {
    List<ChatDataModel> switchedChats = [];
    for (int i = 0; i < chats.length; i += 2) {
      ChatDataModel firstChat = chats[i];
      bool isSecondChatIsDefault = false;
      if (chats.length > i + 1) {
        ChatDataModel secondChat = chats[i + 1];
        switchedChats.insert(switchedChats.length, secondChat);
        isSecondChatIsDefault = secondChat.isDefault;
      }

      if (isSecondChatIsDefault) {
        switchedChats.insert(switchedChats.length - 1, firstChat);
      } else {
        switchedChats.insert(switchedChats.length, firstChat);
      }
    }

    return switchedChats;
  }

  void _removeChatLoading() {
    _chatsToDisplay.removeAt(0);
    _currentOfflineIndex -= 1;
  }

  void _addMessageFromStart(AbsChatModel chat) {
    _chatsToDisplay.insert(0, chat);
    _currentOfflineIndex += 1;
  }

  void _initializeHive() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    Hive.init(appDocDir.path);
    Hive.registerAdapter(ChatDataModelAdapter());
    _loadAllLocal();
  }
}
