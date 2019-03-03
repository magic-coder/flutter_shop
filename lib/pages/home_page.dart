import 'package:flutter/material.dart';
import '../utils/ajax.dart';


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    getHttp();
    return Scaffold(
      body: Center(
        child: Text('HomePage1'),
      ),
    );
  }
  void getHttp() async {
    try {
      var res = await Http.getInstance().get('/5c60131a4bed3a6342711498/baixing/dabaojian', queryParameters: {'name': '王一扬'});
      print(res);
    } catch (e) {
      print(e);
    }
  }
}