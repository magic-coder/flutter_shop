import '../utils/ajax.dart';
import 'dart:async';
import '../config/service_url.dart';

Future getHomePageContent() async {
  const formData = {
    'lon':'115.02932','lat':'35.76189'
  };
  return await Http.getInstance().post(servicePath['homePageContext'], data: formData);
}