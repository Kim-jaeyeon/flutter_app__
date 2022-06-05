import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/main.dart';

void main() => runApp(MyApp());

class WishList {
  bool isChosen = false;
  String title;

  WishList(this.title,
      {this.isChosen = false}); //isChosen 프로퍼티를 옵셔널 프로퍼티로 고치고 기본값을 false로 설정
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '위시리스트',
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: WishListMain(),
    );
  }
}

class WishListMain extends StatefulWidget {
  const WishListMain({Key? key}) : super(key: key);

  @override
  State<WishListMain> createState() => _WishListMainState();
}

class _WishListMainState extends State<WishListMain> {

  var _togetController = TextEditingController();

  void dispose() {
    _togetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('위시리스트'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _togetController,
                  ),
                ),
                CupertinoButton(
                    child: Text('추가'),
                    onPressed: () => _addToget(WishList(_togetController.text))
                    //
                    ),
              ],
            ),
            StreamBuilder<QuerySnapshot>(
                stream:
                    FirebaseFirestore.instance.collection('toget').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator();
                  }
                  final documents = snapshot.data!.docs; //여기에 ?를 넣으면 왜 오류가 뜰까
                  return Expanded(
                      child: ListView(
                    children:
                        documents.map((doc) => _buildItemWidget(doc)).toList(),
                  ));
                }),
          ],
        ),
      ),
    );
  }

  //할 일 객체를 ListTile 형태로 변경하는 메서드
  Widget _buildItemWidget(DocumentSnapshot doc) {
    final wishlist = WishList(doc['title'], isChosen: doc['isChosen']);
    return ListTile(
      onTap: () => _toggleToget(doc),
      title: Text(
        wishlist.title,
        style: wishlist.isChosen
            ? TextStyle(
                decoration: TextDecoration.lineThrough, //취소선
                fontStyle: FontStyle.italic, //이탤릭체
              )
            : null,
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete_forever_outlined),
        onPressed: () => _deleteToget(doc),
      ),
    );
  }

  void _addToget(WishList wishlist) {
    FirebaseFirestore.instance
        .collection('toget')
        .add({'title': wishlist.title, 'isChosen': wishlist.isChosen});
    _togetController.text = '';
  }

  //할 일 삭제 메소드
  void _deleteToget(DocumentSnapshot doc) {
    FirebaseFirestore.instance.collection('toget').doc(doc.id).delete();
  }

  void _toggleToget(DocumentSnapshot doc) {
    FirebaseFirestore.instance
        .collection('toget')
        .doc(doc.id)
        .update({'isChosen': !doc['isChosen']});
  }
}
