import 'package:flutter/material.dart';
import 'package:raptorx/src/core/router/route_name.dart';
import 'package:raptorx/src/features/home/presentation/view/home_screen.dart';

class HomeNavigator extends StatelessWidget {
  const HomeNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          case RouteName.homeRoute:
            return MaterialPageRoute(builder: (_) => const HomeScreen());
          default:
            return MaterialPageRoute(builder: (_) => const HomeScreen());
        }
      },
    );
  }
}
