import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/main.dart';

void main() => runApp(MyApp());

class WishList {
  bool isChosen = false;
  String title;

  WishList(this.title, {this.isChosen=false});//isChosen 프로퍼티를 옵셔널 프로퍼티로 고치고 기본값을 false로 설정
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
  final _items = <WishList>[]; //찜 목록을 저장할 리스트

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
                CupertinoButton(child: Text('추가'),
                    onPressed: () =>
                        _addToget(WishList(_togetController.text))
                    //
                ),
              ],
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('toget').snapshots(),
              builder: (context, snapshot) {
                if(!snapshot.hasData){
                  return CircularProgressIndicator();
                }
                final documents=snapshot.data!.docs;
                return Expanded(
                    child: ListView(
                      children: documents.map((doc) => _buildItemWidget(doc)).toList(),
                    ));
              }
            ),
          ],
        ),
      ),
    );
  }

  //할 일 객체를 ListTile 형태로 변경하는 메서드
  Widget _buildItemWidget(DocumentSnapshot doc) {
    final wishlist=WishList(doc['title'],isChosen: doc['isChosen']);
    return ListTile(
      onTap: () =>_toggleToget(wishlist),
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
        onPressed: () => _deleteToget(wishlist),
      ),
    );
  }

  void _addToget(WishList wishlist) {
    setState(() {
      _items.add(wishlist);
      _togetController.text = ''; //할 일 입력 필드를 비움
    });
  }

  //할 일 삭제 메소드
  void _deleteToget(WishList wishlist) {
    setState(() {
      _items.remove(wishlist);
    });
  }

  void _toggleToget(WishList wishlist) {
    setState(() {
      wishlist.isChosen =
      !wishlist.isChosen; //isChosen값을 변경하고 setState로 UI를 다시 그림
    });
  }
}




