import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:translateapp/bloc/chat_loader/ChatLoaderBloc.dart';
import 'package:translateapp/bloc/chat_loader/chat_loader_event.dart';
import 'package:translateapp/bloc/chat_loader/chat_loader_state.dart';
import 'package:translateapp/model/chat_model.dart';
import 'package:translateapp/widget/chat_me.dart';
import 'package:translateapp/widget/chat_reception.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

// 0xffF7F7F7
class _ChatScreenState extends State<ChatScreen> {
  ChatLoaderBloc _chatLoaderBloc = ChatLoaderBloc();

  @override
  void initState() {
    _chatLoaderBloc.loadChats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ChatLoaderBloc>(
          create: (BuildContext context) => _chatLoaderBloc,
        )
      ],
      child: Scaffold(
        backgroundColor: Color(0xffF7F7F7),
        appBar: AppBar(
          title: Text(
            'Khmer English Translator',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        body: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.03,
              width: double.infinity,
              child: Image.network(
                  'https://www.designcontest.com/blog/wp-content/uploads/2015/07/banner-ad-fail-11.jpg'),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: BlocBuilder<ChatLoaderBloc, ChatLoaderState>(
                  builder: (BuildContext context, ChatLoaderState state) {
                    if (state is OnLoadChatState) {
                      return NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification scrollInfo) {
                          if (scrollInfo.metrics.pixels ==
                              scrollInfo.metrics.maxScrollExtent) {
                            if (state.currentOfflineLength <
                                state.allOfflineLength) {
                              _chatLoaderBloc.add(OnChatLoadMoreEvent());
                            }
                            return true;
                          }
                          return false;
                        },
                        child: ListView.builder(
                            itemCount: (state.currentOfflineLength <=
                                    state.allOfflineLength)
                                ? state.chats.length + 1
                                : state.chats.length,
                            reverse: true,
                            itemBuilder: (BuildContext context, int index) {
                              if (index == state.chats.length &&
                                  state.currentOfflineLength <
                                      state.allOfflineLength) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              ChatModel chat = state.chats[index];
                              bool isChatMe = chat.isMe;
                              if (isChatMe) {
                                return ChatMe(
                                  text: chat.text,
                                  image: chat.assetIcon,
                                );
                              }
                              return ChatReception(
                                text: chat.text,
                                image: chat.assetIcon,
                              );
                            }),
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(.3),
                    offset: Offset(0, -1),
                    spreadRadius: 1,
                    blurRadius: 7)
              ]),
              height: MediaQuery.of(context).size.height * 0.076,
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * .03),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipOval(
                    child: Stack(
                      children: [
                        Image(
                          width: MediaQuery.of(context).size.width * .065,
                          height: MediaQuery.of(context).size.width * .065,
                          image: AssetImage('khmer_flag_round.png'),
                        ),
                        Positioned.fill(
                            child: Material(
                          type: MaterialType.transparency,
                          child: InkWell(
                            onTap: () {},
                          ),
                        ))
                      ],
                    ),
                  ),
                  Expanded(
                    child: TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width * .07),
                          hintText: 'Type something...',
                          hintStyle:
                              TextStyle(color: Colors.grey.withOpacity(.7)),
                          disabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                          enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                          focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.transparent)),
                        )),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      width: MediaQuery.of(context).size.width * .08,
                      height: MediaQuery.of(context).size.width * .08,
                      child: SvgPicture.asset('assets/send_icon.svg'),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
