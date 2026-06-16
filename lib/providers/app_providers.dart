import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// no service imports required here yet

// Auth Provider
class AuthProvider extends ChangeNotifier {

  // TODO: Implement auth state management

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}

// Restaurant Provider
class RestaurantProvider extends ChangeNotifier {
  // TODO: Implement restaurant state management

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}

// Maps Provider
class MapsProvider extends ChangeNotifier {
  // TODO: Implement maps state management

  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}

// App Providers List
List<ChangeNotifierProvider> getAppProviders() {
  return [
    ChangeNotifierProvider(create: (_) => AuthProvider()),
    ChangeNotifierProvider(create: (_) => RestaurantProvider()),
    ChangeNotifierProvider(create: (_) => MapsProvider()),
  ];
}
