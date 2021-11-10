

import 'package:flutter/material.dart';


class AppState extends ChangeNotifier{

  int _counter = 0;
  int get counter => _counter;


  void incrementCounter({int incBy = 1}){
    _counter = (_counter + incBy).clamp(0, 100);
    notifyListeners();
  }
}