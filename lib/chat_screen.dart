import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:translateapp/bloc/chat_loader/chat_loader_bloc.dart';
import 'package:translateapp/bloc/chat_loader/chat_loader_event.dart';
import 'package:translateapp/bloc/chat_loader/chat_loader_state.dart';
import 'package:translateapp/bloc/chat_request/chat_request_bloc.dart';
import 'package:translateapp/bloc/chat_request/chat_request_event.dart';
import 'package:translateapp/model/chat_data_model.dart';
import 'package:translateapp/model/chat_loading_model.dart';
import 'package:translateapp/widget/chat_me.dart';
import 'package:translateapp/widget/chat_reception.dart';

import 'bloc/chat_request/chat_request_state.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

// 0xffF7F7F7
class _ChatScreenState extends State<ChatScreen> {
  ChatLoaderBloc _chatLoaderBloc = ChatLoaderBloc();
  ChatRequestBloc _chatRequestBloc = ChatRequestBloc();

  TextEditingController _messageEditingTextCtrl = TextEditingController();

  @override
  void initState() {
    _chatLoaderBloc.add(InitializeChatEvent());
    super.initState();
  }

  Widget _getSendButton({Function onClick}) {
    return InkWell(
      onTap: onClick,
      child: Container(
        width: MediaQuery.of(context).size.width * .08,
        height: MediaQuery.of(context).size.width * .08,
        child: SvgPicture.asset('assets/send_icon.svg'),
      ),
    );
  }

  Widget _getMessageTextField(bool isEnable, {String hintText}) {
    return TextField(
        enabled: isEnable,
        keyboardType: TextInputType.multiline,
        maxLines: null,
        controller: _messageEditingTextCtrl,
        decoration: InputDecoration(
          contentPadding:
              EdgeInsets.only(left: MediaQuery.of(context).size.width * .07),
          hintText: hintText ?? '',
          hintStyle: TextStyle(color: Colors.grey.withOpacity(.7)),
          disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent)),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent)),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent)),
        ));
  }

  Widget _getEmptyChatWidget() {
    return Center(
      child: Text(
        'No chat yet!',
        style: TextStyle(color: Colors.grey),
      ),
    );
  }

  Widget _getChatLoadingItem(String iconAsset) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.07,
            height: MediaQuery.of(context).size.width * 0.07,
            child: CircleAvatar(
              backgroundImage: AssetImage(iconAsset),
            ),
          ),
          SizedBox(
            width: 5,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * .2,
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
                child: SpinKitThreeBounce(
                  color: Colors.white,
                  size: MediaQuery.of(context).size.width * .03,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ChatLoaderBloc>(
          create: (BuildContext context) => _chatLoaderBloc,
        ),
        BlocProvider<ChatRequestBloc>(
          create: (BuildContext context) => _chatRequestBloc,
        )
      ],
      child: Scaffold(
        backgroundColor: Color(0xffF7F7F7),
        appBar: AppBar(
          title: Text(
            'English Japan Translator',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        body: Column(
          children: [
            BlocListener<ChatRequestBloc, ChatRequestState>(
              listener: (BuildContext context, ChatRequestState state) {
                if (state is OnTranslateSuccessState) {
                  _chatLoaderBloc.add(OnAddTranslatedMessageEvent(state.chat));
                }

                if (state is OnLoadToTranslateTextState) {
                  _messageEditingTextCtrl.text = '';
                  _chatLoaderBloc.add(LoadToTranslateChatEvent(state.chat));
                }

                if (state is OnTranslateFailState) {
                  _chatLoaderBloc.add(OnRemoveChatLoadingEvent());
                  AlertDialog errorDialog = AlertDialog(
                    title: Text(state.errorMessage.title),
                    content: Text(state.errorMessage.description),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Ok'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  );
                  showDialog(context: context, builder: (_) => errorDialog);
                }
              },
              child: SizedBox.shrink(),
            ),
            Container(
              height: MediaQuery.of(context).size.height * .08,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: BlocBuilder<ChatLoaderBloc, ChatLoaderState>(
                  builder: (BuildContext context, ChatLoaderState state) {
                    if (state is OnLoadChatState) {
                      bool noChatsYet = state.chats.length == 0;
                      if (noChatsYet) {
                        return _getEmptyChatWidget();
                      }
                      print("Chat Screen all chat ${state.chats.length}");
                      return NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification scrollInfo) {
                          bool shouldLoadMore = scrollInfo.metrics.pixels ==
                                  scrollInfo.metrics.maxScrollExtent &&
                              state.currentOfflineIndex <
                                  state.allOfflineLength;
                          if (shouldLoadMore) {
                            _chatLoaderBloc.add(OnLoadMoreEvent());
                          }
                          return false;
                        },
                        child: ListView.builder(
                            itemCount: (state.currentOfflineIndex <
                                    state.allOfflineLength)
                                ? state.chats.length + 1
                                : state.chats.length,
                            reverse: true,
                            itemBuilder: (BuildContext context, int index) {
                              if (index == 0 &&
                                  state.chats[0] is ChatLoadingModel) {
                                return _getChatLoadingItem(state.isSwap
                                    ? ChatDataModel.CHAT_ME_ICON
                                    : ChatDataModel.CHAT_RECEPTION_ICON);
                              }
                              if (index == state.chats.length &&
                                  state.currentOfflineIndex <
                                      state.allOfflineLength) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              print("CURRENT INDEX $index");
                              ChatDataModel chat = state.chats[index];
                              bool isChatMe = chat.isMe;
                              if (isChatMe) {
                                return ChatMe(
                                  text: chat.text,
                                  image: chat.icon,
                                );
                              }
                              return ChatReception(
                                text: chat.text,
                                image: chat.icon,
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
                  BlocBuilder<ChatLoaderBloc, ChatLoaderState>(
                    builder: (BuildContext context, ChatLoaderState state) {
                      if (state is OnLoadChatState) {
                        if (state.isSwap) {
                          return ClipOval(
                            child: Stack(
                              children: [
                                Image(
                                  width:
                                      MediaQuery.of(context).size.width * .065,
                                  height:
                                      MediaQuery.of(context).size.width * .065,
                                  image: AssetImage('assets/japan_english.png'),
                                ),
                                Positioned.fill(
                                    child: Material(
                                  type: MaterialType.transparency,
                                  child: InkWell(
                                    onTap: () {
                                      _chatLoaderBloc
                                          .add(OnSwapLanguageEvent());
                                      _chatRequestBloc
                                          .add(OnSwitchLanguageEvent());
                                    },
                                  ),
                                ))
                              ],
                            ),
                          );
                        }
                        return ClipOval(
                          child: Stack(
                            children: [
                              Image(
                                width: MediaQuery.of(context).size.width * .065,
                                height:
                                    MediaQuery.of(context).size.width * .065,
                                image: AssetImage('assets/english_japan.png'),
                              ),
                              Positioned.fill(
                                  child: Material(
                                type: MaterialType.transparency,
                                child: InkWell(
                                  onTap: () {
                                    _chatLoaderBloc.add(OnSwapLanguageEvent());
                                    _chatRequestBloc
                                        .add(OnSwitchLanguageEvent());
                                  },
                                ),
                              ))
                            ],
                          ),
                        );
                      }
                      return Container(
                        width: MediaQuery.of(context).size.width * .065,
                        height: MediaQuery.of(context).size.width * .065,
                        child: CircleAvatar(
                          backgroundColor: Colors.grey.withOpacity(.5),
                        ),
                      );
                    },
                  ),
                  Expanded(
                    child: BlocBuilder<ChatLoaderBloc, ChatLoaderState>(
                      builder: (BuildContext context, ChatLoaderState state) {
                        if (state is OnLoadChatState) {
                          return _getMessageTextField(state.isInputEnable,
                              hintText: state.inputHintText);
                        }
                        return _getMessageTextField(false);
                      },
                    ),
                  ),
                  BlocBuilder<ChatLoaderBloc, ChatLoaderState>(
                    builder: (BuildContext context, ChatLoaderState state) {
                      if (state is OnLoadChatState) {
                        return _getSendButton(onClick: () {
                          if (_messageEditingTextCtrl.text.isNotEmpty) {
                            _chatRequestBloc.add(OnSubmitMessageEvent(
                                _messageEditingTextCtrl.text));
                          }
                        });
                      }
                      return _getSendButton();
                    },
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
