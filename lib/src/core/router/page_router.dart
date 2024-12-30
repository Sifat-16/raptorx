import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:raptorx/src/core/navigation/main_navigation_view.dart';
import 'package:raptorx/src/core/router/route_name.dart';
import 'package:raptorx/src/features/auth/presentation/view_model/auth_controller.dart';
import 'package:raptorx/src/features/home/presentation/view/home_screen.dart';
import 'package:raptorx/src/features/settings/presentation/view/settings_screen.dart';
import 'package:raptorx/src/features/welcome/presentation/view/welcome_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  User? user = ref.read(authProvider.notifier).authState();
  final rootNavigatorKey = GlobalKey<NavigatorState>();
  final homeNavigatorKey = GlobalKey<NavigatorState>();
  final brandNavigatorKey = GlobalKey<NavigatorState>();
  return GoRouter(
      navigatorKey: rootNavigatorKey,
      observers: [BotToastNavigatorObserver(), CustomNavigationObserver()],
      initialLocation: user == null ? "/welcome" : "/home",
      routes: [
        GoRoute(
            path: "/welcome",
            name: RouteName.welcomeRoute,
            builder: (context, state) {
              return const WelcomeScreen();
            }),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigator) {
            return MainNavigationView(navigator: navigator);
          },
          branches: <StatefulShellBranch>[
            StatefulShellBranch(
                navigatorKey: homeNavigatorKey,
                routes: <RouteBase>[
                  GoRoute(
                      path: "/home",
                      name: RouteName.homeRoute,
                      builder: (context, state) {
                        return const HomeScreen();
                      })
                ]),
            StatefulShellBranch(routes: <RouteBase>[
              GoRoute(
                path: "/settings",
                name: RouteName.settingsRoute,
                builder: (context, state) {
                  return const SettingsScreen();
                },
              )
            ]),
          ],
        )
      ]);
});

class CustomNavigationObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print(
        "Navigation status Pushed ${route.toString()}-${previousRoute.toString()}");
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    print(
        "Navigation status Replaced ${newRoute.toString()}-${oldRoute.toString()}");
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print(
        "Navigation status Removed ${route.toString()}-${previousRoute.toString()}");
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print(
        "Navigation status Popped ${route.toString()}-${previousRoute.toString()}");
  }
}
