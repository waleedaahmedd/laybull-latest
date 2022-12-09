import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:laybull_v3/util_services/firebase_service.dart';
import 'package:laybull_v3/util_services/http_service.dart';
import 'package:laybull_v3/util_services/storage_service.dart';
import 'package:laybull_v3/util_services/utilservices.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  try {
    locator.registerSingleton(UtilService());
    locator.registerSingleton(StorageService());
    locator.registerSingleton(HttpService());
    locator.registerSingleton(FirebaseService());
  } catch (err) {
    if (kDebugMode) {
      print('locator error');
    }
  }
}
