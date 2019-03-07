import '../utils/ajax.dart';
import 'dart:async';
import '../config/service_url.dart';

Future getHomePageContent(data) async {
  return await Http.getInstance().post(servicePath['homePageContext'], data: data);
}
// 火爆专区
Future getHomePageBelowConten(data) async {
  return await Http.getInstance().post(servicePath['homePageBelowConten'], data: data);
}

