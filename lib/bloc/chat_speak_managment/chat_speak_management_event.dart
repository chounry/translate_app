class ChatSpeakManagementEvent {}

class OnIAmSpeakingEvent extends ChatSpeakManagementEvent {
  final int index;

  OnIAmSpeakingEvent(this.index);
}
