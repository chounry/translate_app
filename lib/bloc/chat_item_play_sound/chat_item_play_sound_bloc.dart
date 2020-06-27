import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:translateapp/bloc/chat_loader/chat_loader_bloc.dart';

import 'chat_item_play_sound_event.dart';
import 'chat_item_play_sound_state.dart';

class ChatItemPlaySoundBloc
    extends Bloc<ChatItemPlaySoundEvent, ChatItemPlaySoundState> {
  String _text;

  // speak
  FlutterTts flutterTts;
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;

  TtsState _ttsState = TtsState.stopped;

  ChatItemPlaySoundBloc(String chatText) {
    _text = chatText;
    _initializeSpeak();
  }

  @override
  ChatItemPlaySoundState get initialState => ChatItemPlaySoundState();

  @override
  Stream<ChatItemPlaySoundState> mapEventToState(
      ChatItemPlaySoundEvent event) async* {
    if (event is OnPlayClickEvent) {
      _speak();
      yield OnDisplayPauseIconState();
    }

    if (event is StopEvent) {
      if (_ttsState == TtsState.playing) {
        print("Some thing $_ttsState");
        _ttsState = TtsState.stopped;
        await flutterTts.stop();
      }
//      yield ChatItemPlaySoundState();
      yield OnDisplayPlayIconState();
    }
  }

  void stopSpeaking() {
    _ttsState = TtsState.stopped;
    add(StopEvent());
  }

  void _initializeSpeak() {
    flutterTts = FlutterTts();

    flutterTts.setStartHandler(() {
      print("playing");
      _ttsState = TtsState.playing;
    });

    flutterTts.setCompletionHandler(() {
      stopSpeaking();
    });

    flutterTts.setErrorHandler((msg) {
      print("error: $msg");
      stopSpeaking();
    });
  }

  void _speak() async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);
    String textToSpeak = _text;

    var result = await flutterTts.speak(textToSpeak);
    if (result == 1) _ttsState = TtsState.playing;
  }
}
