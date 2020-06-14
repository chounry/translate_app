import 'package:flutter/material.dart';

class ChatReception extends StatelessWidget {
  final String text;
  final String image;
  final Function onSpeakClick;

  const ChatReception(
      {Key key, @required this.text, @required this.image, this.onSpeakClick})
      : super(key: key); // TODO : put this to required

  @override
  Widget build(BuildContext context) {
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
              backgroundImage: AssetImage(image),
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
                  text,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              GestureDetector(
                onTap: onSpeakClick,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.volume_up,
                    size: 20,
                    color: Colors.grey.withOpacity(.5),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
