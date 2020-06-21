import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translateapp/bloc/chat_item_play_sound/chat_item_play_sound_bloc.dart';
import 'package:translateapp/bloc/chat_item_play_sound/chat_item_play_sound_event.dart';
import 'package:translateapp/bloc/chat_item_play_sound/chat_item_play_sound_state.dart';

class ChatReception extends StatefulWidget {
  final String text;
  final String image;

  const ChatReception({Key key, @required this.text, @required this.image})
      : super(key: key);

  @override
  _ChatReceptionState createState() => _ChatReceptionState();
}

class _ChatReceptionState extends State<ChatReception> {
  ChatItemPlaySoundBloc _chatItemBloc;

  @override
  void initState() {
    _chatItemBloc = ChatItemPlaySoundBloc(widget.text);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChatItemPlaySoundBloc>(
      create: (BuildContext context) => _chatItemBloc,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.07,
              height: MediaQuery.of(context).size.width * 0.07,
              child: CircleAvatar(
                backgroundImage: AssetImage(widget.image),
              ),
            ),
            SizedBox(
              width: 5,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.65,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10)),
                      color: Color(0xff917ADC),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3))
                      ]),
                  padding: EdgeInsets.all(10),
                  child: Text(
                    widget.text,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                BlocBuilder<ChatItemPlaySoundBloc, ChatItemPlaySoundState>(
                  builder:
                      (BuildContext context, ChatItemPlaySoundState state) {
                    print("STATE $state");
                    if (state is OnDisplayPauseIconState) {
                      print("STATE in $state");
                      return GestureDetector(
                        onTap: () {
                          _chatItemBloc.add(StopEvent());
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.pause,
                            size: MediaQuery.of(context).size.width * .04,
                            color: Colors.grey.withOpacity(.5),
                          ),
                        ),
                      );
                    }
                    print("ON NO");
                    return GestureDetector(
                      onTap: () {
                        _chatItemBloc.add(OnPlayClickEvent());
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.volume_up,
                          size: MediaQuery.of(context).size.width * .04,
                          color: Colors.grey.withOpacity(.5),
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
