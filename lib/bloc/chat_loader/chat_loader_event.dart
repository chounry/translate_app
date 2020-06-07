import 'package:translateapp/model/chat_model.dart';

class ChatLoaderEvent {}

class OnChatLoadedEvent extends ChatLoaderEvent {}

class OnChatLoadMoreEvent extends ChatLoaderEvent {}

class OnSwapLanguageEvent extends ChatLoaderEvent {}
