import 'package:flutter/material.dart';
import 'package:translateapp/widget/chat_me.dart';
import 'package:translateapp/widget/chat_reception.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

// 0xffF7F7F7
class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF7F7F7),
      appBar: AppBar(
        title: Text('Khmer English Translator'),
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
            child: Container(
              child: Column(
                children: [ChatMe(), ChatReception()],
              ),
            ),
          ),
          Container(
            color: Colors.grey,
            height: MediaQuery.of(context).size.height * 0.05,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FlatButton(
                  onPressed: () {},
                  child: Image.asset('assets/khmer_flag.png'),
                ),
                Expanded(
                  child: TextFormField(
                      decoration: InputDecoration(
                    hintText: 'Type something...',
                    suffixIcon: Icon(Icons.send),
                    disabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent)),
                  )),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
