import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translateapp/bloc/chat_loader/chat_loader_event.dart';
import 'package:translateapp/bloc/chat_loader/chat_loader_state.dart';
import 'package:translateapp/model/chat_model.dart';

class ChatLoaderBloc extends Bloc<ChatLoaderEvent, ChatLoaderState> {
  static const PAGE_SIZE = 10;
  int _currentOfflineLength = 0;
  int _allOfflineLength = 15;
  List<ChatModel> _chats = [];

  @override
  ChatLoaderState get initialState => ChatLoaderState();

  @override
  Stream<ChatLoaderState> mapEventToState(ChatLoaderEvent event) async* {
    if (event is OnChatLoadedEvent) {
      yield OnLoadChatState(
          allOfflineLength: _allOfflineLength,
          currentOfflineLength: _currentOfflineLength,
          chats: _chats);
    }

    if (event is OnChatLoadMoreEvent) {
      loadChats();
    }

    if (event is OnAddNewMessageEvent) {
      _addMessageFromStart(event.getChats());
    }
  }

  void loadChats() async {
    Future.delayed(Duration(seconds: 1), () {
      List<ChatModel> chats = [];
      if (_currentOfflineLength < _allOfflineLength) {
        if ((_currentOfflineLength + PAGE_SIZE) > _allOfflineLength) {
          chats = ChatModel.getChats(PAGE_SIZE);
        } else {
          chats = ChatModel.getChats(PAGE_SIZE);
        }
        _chats.addAll(chats);
        add(OnChatLoadedEvent());

        _currentOfflineLength += PAGE_SIZE;
      }
    });
  }

  void _addMessageFromStart(List<ChatModel> chats) {
    print("_addMessageFromStart ${chats.length}");
    _chats.insertAll(0, chats);

    add(OnChatLoadedEvent());
  }
}
