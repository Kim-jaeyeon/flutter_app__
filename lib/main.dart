import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; //머티리얼 위젯

import 'package:flutter_app/StopWatch.dart';
import 'package:flutter_app/BmiMain.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_app/WishListMain.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final dummyItems = [
  'assets/IMG_9303.jpg',
  'assets/IMG_1308.JPG',
  'assets/IMG_1856.JPG',
  'assets/IMG_3916.JPG',
  'assets/IMG_5158.JPG',
];

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); //Firebase 초기화
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _index = 0;
  var _pages = [Page1(), BmiMain(), StopWatch()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            _index = index;
          });
        },
        currentIndex: _index,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(label: '홈', icon: Icon(Icons.home)),
          BottomNavigationBarItem(label: '이용서비스', icon: Icon(Icons.assignment)),
          BottomNavigationBarItem(
              label: '내 정보', icon: Icon(Icons.account_circle)),
        ],
      ),
    );
  }

}

class Page1 extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
        centerTitle: true,
        title: const Text(
          'JY_Home',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange,
        actions: <Widget>[
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ))
        ],
      ),
      body: ListView(
        children: <Widget>[_buildTop(context), _buildMiddle(), _buildBottom()],
      ),
    );
  }

  Widget _buildTop(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              InkWell(
                onTap: () {

                },
                child: Column(
                  children: const <Widget>[Icon(
                    Icons.camera,
                    size: 40,
                  ),
                    Text('갤러리')],
                ),
              ),
              InkWell(
                onTap: () {

                },
                child: Column(
                  children: const <Widget>[Icon(
                    Icons.camera_enhance,
                    size: 40,
                  ),
                    Text('뷰티카메라')],
                ),
              ),
              InkWell(
                onTap: () {

                },
                child: Column(
                  children: const <Widget>[Icon(
                    Icons.camera_alt,
                    size: 40,
                  ),
                    Text('기본카메라')],
                ),
              ),
              InkWell(
                onTap: () {

                },
                child: Column(
                  children: const <Widget>[Icon(
                    Icons.camera_indoor,
                    size: 40,
                  ),
                    Text('동영상')],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              InkWell(
                onTap: () {

                },
                child: Column(
                  children: const <Widget>[Icon(
                    Icons.store,
                    size: 40,
                  ),
                    Text('뷰티')],
                ),
              ),
              InkWell(
                onTap: () {

                },
                child: Column(
                  children: const <Widget>[Icon(
                    Icons.storefront_outlined,
                    size: 40,
                  ),
                    Text('잡화상점')],
                ),
              ),

              InkWell(
                child: Column(
                  children: const <Widget>[Icon(
                    Icons.storage_outlined,
                    size: 40,
                  ),
                    Text('찜목록')],
                ),
                onTap: ()async =>{
                  await Navigator.push(context, MaterialPageRoute(builder: (context)=>WishListMain()))
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiddle() {
    return CarouselSlider(
      options: CarouselOptions(height: 400.0, autoPlay: true), //높이 400
      items: dummyItems.map((url) { //5페이지
        return Builder(
          builder: (BuildContext context) {
            return Container(
                width: MediaQuery
                    .of(context)
                    .size
                    .width, //context를 사용하고자 할 때, 기기의 가로 길이
                margin: EdgeInsets.symmetric(horizontal: 5.0), //좌우여백 5
                decoration: const BoxDecoration(
                    color: Colors.white //배경색
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    url,
                    fit: BoxFit.cover,
                  ),
                )
            );
          },
        );
      }).toList(),
    );
  }

  Widget _buildBottom() {
    final items = List.generate(10, (i) {
      return const ListTile(
        leading: Icon(Icons.notification_add_outlined),
        title: Text('[후기] 구매 후기 남깁니다!!'),
      );
    });

    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: items,
    );
  }

}








