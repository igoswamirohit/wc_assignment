import 'package:flutter/material.dart';

import '../data/models/user_model.dart';
import '../ui/screens/home_view.dart';
import '../ui/screens/user_detail_view.dart';

class RouteManager {
  static MaterialPageRoute<void> onGenerateRoute(RouteSettings routeSettings) {
    return MaterialPageRoute<void>(
      settings: routeSettings,
      builder: (BuildContext context) {
        switch (routeSettings.name) {
          case UserDetailView.routeName:
            return UserDetailView(
              userModel: routeSettings.arguments as UserModel,
            );
          case HomeView.routeName:
          default:
            return const HomeView();
        }
      },
    );
  }
}
