import 'package:flutter/material.dart';

class ChatMe extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                    bottomRight: Radius.circular(5)),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3))
                ]),
            padding: EdgeInsets.all(10),
            child: Text(
                'Hellkejrglkjdkfgjlkfd jlgkj dflkjg lkfdj glkjfd lkgjfdl ksjflkgjslfdkgjldskfjgkjfdsglkjo\n\n\nwerewrew'),
          ),
          SizedBox(
            width: 5,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.07,
            height: MediaQuery.of(context).size.width * 0.07,
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/khmer_flag.png'),
            ),
          )
        ],
      ),
    );
  }
}
