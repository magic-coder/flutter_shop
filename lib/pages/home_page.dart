import 'package:flutter/material.dart';
import '../utils/ajax.dart';


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String text = '暂无数据';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              RaisedButton(
                child: Text('获取数据'),
                onPressed: (){
                  getRes();
                },
              ),
              Text(text)
            ],
          ),
        ),
      ),
    );
  }

  void getRes() {
    getHttp().then((v){
      setState(() {
       text = v['data'].toString(); 
      });
    });
  }

  Future getHttp() async {
    var res = await Http.getInstance().post('https://time.geekbang.org/serv/v1/column/newAll');
    print(res);
    return res;
  }
}