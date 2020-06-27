import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translateapp/bloc/chat_item_play_sound/chat_item_play_sound_bloc.dart';
import 'package:translateapp/bloc/chat_speak_managment/chat_speak_management_event.dart';
import 'package:translateapp/bloc/chat_speak_managment/chat_speak_management_state.dart';

class ChatSpeakManagementBloc
    extends Bloc<ChatSpeakManagementEvent, ChatSpeakManagementState> {
  List<ChatItemPlaySoundBloc> _allChatItemSoundBloc = [];

  @override
  ChatSpeakManagementState get initialState => ChatSpeakManagementState();

  @override
  Stream<ChatSpeakManagementState> mapEventToState(
      ChatSpeakManagementEvent event) async* {
    if (event is OnIAmSpeakingEvent) {
      for (int i = 0; i < _allChatItemSoundBloc.length; i++) {
        if (i != event.index) {
          _allChatItemSoundBloc[i].stopSpeaking();
        }
      }
    }
  }

  void addChatSoundBloc(ChatItemPlaySoundBloc bloc) {
    _allChatItemSoundBloc.add(bloc);
  }

  int get getLastIndex => _allChatItemSoundBloc.length - 1;

  void clearChatItemSoundBlocList(){
    _allChatItemSoundBloc = [];
  }
}
