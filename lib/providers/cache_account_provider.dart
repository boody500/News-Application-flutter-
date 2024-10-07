import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:hagora/services/cache_service.dart';

class CacheAccountProvider with ChangeNotifier {

  CacheHelper service = CacheHelper();




  insertUser(String user)async{
    service.insertUser(user);
    notifyListeners();
  }

  deleteUser(String user) async{
    service.deleteUser(user);
    notifyListeners();
  }

  Future<String> getCurrentUser() async{
    Map<String, String> temp = await service.getCurrentUser();
    print(temp['email']);
    return temp['email']!;
  }

}

