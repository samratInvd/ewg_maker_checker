import 'dart:html';
import 'package:flutter/material.dart';

class RoutesProvider extends ChangeNotifier {
  /// This code defines a private variable and a public getter/setter method to manage the selected
  /// route and notify listeners of any changes.
  /// 
  /// Args:
  ///   route (String): route is a String parameter that represents the new route that is being set as
  /// the selected route. It is used in the method `setSelectedRoute` to update the value of
  /// `_selectedRoute`.
  String _selectedRoute = "/clientDetails";
  String get selectedRoute => _selectedRoute;
  

  void setSelectedRoute(String route) {
    _selectedRoute = route;
    notifyListeners();
  }



  int _currentTab = 0;
  int get currentTab => _currentTab;

  int _subCurrentTab = 0;
  int get subCurrentTab => _subCurrentTab;

  void setCurrentTab(int tab) {
    _currentTab = tab;
    notifyListeners();
  }

  void setSubCurrentTab(int tab) {
    _subCurrentTab = tab;
    notifyListeners();
  }

}