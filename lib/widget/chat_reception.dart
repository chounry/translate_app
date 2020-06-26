import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:translateapp/bloc/chat_item_copy/chat_item_copy_bloc.dart';
import 'package:translateapp/bloc/chat_item_copy/chat_item_copy_event.dart';
import 'package:translateapp/bloc/chat_item_copy/chat_item_copy_state.dart';
import 'package:translateapp/bloc/chat_item_play_sound/chat_item_play_sound_bloc.dart';
import 'package:translateapp/bloc/chat_item_play_sound/chat_item_play_sound_event.dart';
import 'package:translateapp/bloc/chat_item_play_sound/chat_item_play_sound_state.dart';

class ChatReception extends StatefulWidget {
  final String text;
  final String image;
  final bool isDefaultChat;

  const ChatReception(
      {Key key,
      @required this.text,
      @required this.image,
      this.isDefaultChat = false})
      : super(key: key);

  @override
  _ChatReceptionState createState() => _ChatReceptionState();
}

class _ChatReceptionState extends State<ChatReception> {
  ChatItemPlaySoundBloc _chatItemPlaySoundBloc;
  ChatItemCopyBloc _chatItemCopyBloc;

  @override
  void initState() {
    _chatItemPlaySoundBloc = ChatItemPlaySoundBloc(widget.text);
    _chatItemCopyBloc = ChatItemCopyBloc(widget.text);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ChatItemPlaySoundBloc>(
          create: (BuildContext context) => _chatItemPlaySoundBloc,
        ),
        BlocProvider<ChatItemCopyBloc>(
          create: (BuildContext context) => _chatItemCopyBloc,
        )
      ],
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Builder(
              builder: (BuildContext context) {
                if (widget.isDefaultChat) {
                  return Container(
                    width: MediaQuery.of(context).size.width * 0.1,
                    height: MediaQuery.of(context).size.width * 0.1,
                    child: CircleAvatar(
                      backgroundImage: AssetImage(widget.image),
                    ),
                  );
                }

                return Container(
                  width: MediaQuery.of(context).size.width * 0.07,
                  height: MediaQuery.of(context).size.width * 0.07,
                  child: CircleAvatar(
                    backgroundImage: AssetImage(widget.image),
                  ),
                );
              },
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
                          _chatItemPlaySoundBloc.add(StopEvent());
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
                    print("STATE in here $state");
                    return GestureDetector(
                      onTap: () {
                        _chatItemPlaySoundBloc.add(OnPlayClickEvent());
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
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8, left: 3),
                  child: BlocBuilder<ChatItemCopyBloc, ChatItemCopyState>(
                    builder: (BuildContext context, ChatItemCopyState state) {
                      if (state is OnDisplayCopiedTextState) {
                        return Text(
                          'copied',
                          style: TextStyle(
                              color: Colors.grey.withOpacity(.5),
                              fontSize:
                                  MediaQuery.of(context).size.width * .03),
                        );
                      }

                      return GestureDetector(
                        onTap: () {
                          _chatItemCopyBloc.add(OnCopyClickEvent());
                        },
                        child: Icon(
                          Icons.content_copy,
                          size: MediaQuery.of(context).size.width * .04,
                          color: Colors.grey.withOpacity(.5),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
