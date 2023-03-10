import 'package:flutter/material.dart';

class NavigationNotifier extends ChangeNotifier{
  double scale = 0;
  bool drawerOpened = false;
  TickerProvider ticker;

  NavigationNotifier({required this.ticker}){
    scaleController.forward();
  }

  late final AnimationController scaleController = AnimationController(
    duration: const Duration(milliseconds: 500),
    reverseDuration: const Duration(milliseconds: 500),
    vsync: ticker,
  );


  late final Animation<double> animation = CurvedAnimation(
    parent: scaleController,
    curve: Curves.linear,
  );
  late Tween<double> tween = Tween(begin: 0, end: 0);


  void updateDrawerState(bool boolState){
    drawerOpened = boolState;
    switch(drawerOpened){
      case true:
        scale = 1;
        notifyListeners();
        // scaleController.reverse();
        break;
      default:
        scale = 0;
        notifyListeners();
        // scaleController.forward();
        break;
    }
  }

}