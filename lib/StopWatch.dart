import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';




class StopWatch extends StatefulWidget {
  const StopWatch({Key? key}) : super(key: key);

  @override
  State<StopWatch> createState() => _StopWatchState();
}

class _StopWatchState extends State<StopWatch> {

  late Timer _timer;
  var _time=0;
  var _isRunning=false;

  List<String> _lapTimes=[];

  @override
  void dispose(){
    _timer.cancel(); // 한 번도 실행 시키지 않고 종료시켰을 때 null일 수 있음
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
        centerTitle: true,
        title: const Text(
          'JY_StopWatch',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        child: _isRunning ? Icon(Icons.pause_circle_filled_outlined,color: Colors.white,):Icon(Icons.play_arrow_outlined,color: Colors.white,),
        onPressed: ()=>setState((){
          _clickBtn();
        }),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildBody(){

    var sec=_time~/100; //초
    var hundredth='${_time%100}'.padLeft(2,'0');//  1/100초
    //padLeft(2,'0')= 1/100초는 00~99까지 나타내는 수 중에서 빈 공간을 왼쪽부터 2자리를 0으로
    //채운다는 것이다.

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top:30),
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text('$sec',style: TextStyle(fontSize: 50),),
                    Text('$hundredth'),
                  ],
                ),
                Container(
                  width: 100,
                  height: 200,
                  child: ListView(
                    children: _lapTimes.map((time) => Text(time)).toList(),
                  ),
                )
              ],
            ),
            Positioned(
                left: 10,
              bottom: 30,
              child: FloatingActionButton(
                backgroundColor: Colors.deepOrange,
                onPressed: _reset,
                child: Icon(Icons.rotate_left_outlined,color: Colors.white,),
              ),
            ),
            Positioned(
              right: 10,
              bottom: 35,
              child: CupertinoButton(
                padding: const EdgeInsets.only(right: 20,left: 20),
                color: Colors.orange,
                onPressed: (){
                  setState((){
                    _recordLapTime('$sec.$hundredth');
                  });
                },
                child: Text('랩타임',style: TextStyle(color: Colors.white),),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _clickBtn(){
    _isRunning=!_isRunning;
    
    if(_isRunning){
      _start();
    }
    else{
      _pause();
    }
  }

  //1/100초에 한 번씩 time 변수를 1 증가
  void _start(){
    _timer=Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState((){
        _time++;
      });
    });
  }


  //타이머 취소
  void _pause(){
    _timer.cancel();
  }

  void _reset(){
    setState((){
      _isRunning=false;
      _timer.cancel();
      _lapTimes.clear();
      _time=0;
    });
  }

  void _recordLapTime(String time){
    _lapTimes.insert(0, '${_lapTimes.length+1}등: $time');
  }
}



