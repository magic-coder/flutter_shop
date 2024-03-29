import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './home_page.dart';
import './category_page.dart';
import './cart_page.dart';
import './member_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IndexPage extends StatefulWidget {
  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  final List<BottomNavigationBarItem> bottomTabs = [
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.home),
      title: Text("首页")
    ),
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.search),
      title: Text("分类")
    ),
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.shopping_cart),
      title: Text("购物车")
    ),
    BottomNavigationBarItem(
      icon: Icon(CupertinoIcons.plus_circled),
      title: Text("个人中心")
    )
  ];
  final List<Widget> tabBodies = [
    HomePage(),
    CategoryPage(),
    CartPage(),
    MemberPage()
  ];
  int currentIndex = 0;

  @override
  void initState() { //页面初始化
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    
    //初始化Screenutil屏幕适配方案
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    // print(ScreenUtil.screenHeight);
    // print(ScreenUtil.screenWidth);
    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 245, 245, 1),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: bottomTabs,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      body: IndexedStack(
        index: currentIndex,
        children: tabBodies,
      ),
    );
  }
}