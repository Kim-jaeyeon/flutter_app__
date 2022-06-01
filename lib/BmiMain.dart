import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BmiMain extends StatefulWidget {
  @override
  _BmiMainState createState() => _BmiMainState();
}

class _BmiMainState extends State<BmiMain> {
  //TextField의 현잿값을 얻는 데 필요
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _heightController.addListener(_printLatestValue);
    _weightController.addListener(_printLatestValue);
  }

  _printLatestValue() {
    print('첫 번째 text field: ${_heightController.text}');
    print('두 번째 text field: ${_weightController.text}');
  }

  void dispose() {
    //화면이 종료될 때에는 반드시 위젯트리에서 컨트롤러를 해제해야 함
    _heightController.dispose();
    _weightController.dispose();
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
          'JY_비만도 계산기',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange,
        actions: <Widget>[
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ))
        ],
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(hintText: ' 키(cm)'),
                keyboardType: TextInputType.number,
                controller: _heightController,
                validator: (value) {
                  if (value
                      .toString()
                      .trim()
                      .isEmpty) {
                    return '키를 입력하세요!';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                decoration: const InputDecoration(hintText: ' 몸무게(kg)'),
                keyboardType: TextInputType.number,
                controller: _weightController,
                validator: (value) {
                  if (value
                      .toString()
                      .trim()
                      .isEmpty) {
                    return '몸무게를 입력하세요!';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Container(
                  alignment: Alignment.center,
                  child: CupertinoButton(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.orange,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) =>
                                BmiResult(
                                    double.parse(_heightController.text.trim()),
                                    double.parse(_weightController.text.trim())))
                        );
                      }
                    },
                    child: const Text(
                      '결과',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class BmiResult extends StatelessWidget {
  final double height;
  final double weight;

  const BmiResult(this.height, this.weight);

  @override
  Widget build(BuildContext context) {
    final bmi = weight / ((height / 100) * (height / 100));
    print('h : $height');
    print('w : $weight');
    print('bmi : $bmi');

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              //수정할 부분(글자)
              _calcBmi(bmi),
              style: const TextStyle(fontSize: 36),
            ),
            const SizedBox(
              height: 16,
            ),
            _buildIcon(bmi),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Container(
                alignment: Alignment.center,
                child: CupertinoButton(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.orange,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    '돌아가기',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  String _calcBmi(double bmi) {
    var result = '저체중';
    if (bmi >= 35) {
      result = '고도비만';
    }
    else if (bmi >= 30) {
      result = '2단계 비만';
    }
    else if (bmi >= 25) {
      result = '1단계 비만';
    }
    else if (bmi >= 23) {
      result = '과체중';
    }
    else if (bmi >= 18.5) {
      result = '정상';
    }
    return result;
  }

  Widget _buildIcon(double bmi) {
    if (bmi >= 23) {
      return const Icon(
        Icons.sentiment_very_dissatisfied,
        color: Colors.red,
        size: 100,
      );
    }
    else if (bmi >= 18.5) {
      return const Icon(
        Icons.sentiment_satisfied,
        color: Colors.green,
        size: 100,
      );
    }
    else {
      return const Icon(
        Icons.sentiment_dissatisfied,
        color: Colors.orange,
        size: 100,
      );
    }

  }


}
