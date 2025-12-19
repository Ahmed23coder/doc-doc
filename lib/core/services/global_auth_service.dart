import 'package:docdoc/core/services/secure_storage_service.dart';
import 'package:flutter/cupertino.dart';

class GlobalAuthService {
  GlobalAuthService._internal();
  static final GlobalAuthService instance = GlobalAuthService._internal();
  final _secureStorage = SecureStorageService();


  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  void forceLogout(){
    _clearUserSession();

    navigatorKey.currentState?.pushNamedAndRemoveUntil('/signIn', (route) => false,);
  }

  Future<void> _clearUserSession() async{
    await _secureStorage.clearAll();
  }



  }


