import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:raptorx/src/core/navigation/main_navigation_view.dart';
import 'package:raptorx/src/core/router/route_name.dart';
import 'package:raptorx/src/features/auth/presentation/view/auth_screen.dart';
import 'package:raptorx/src/features/auth/presentation/view_model/auth_controller.dart';
import 'package:raptorx/src/features/brand/brands/presentation/view/brand_screen.dart';
import 'package:raptorx/src/features/brand/create_brand/presentation/view/create_brand.dart';

import 'package:raptorx/src/features/home/presentation/view/home_screen.dart';
import 'package:raptorx/src/features/settings/presentation/view/settings_screen.dart';



final goRouterProvider = Provider<GoRouter>((ref) {
  User? user = ref.read(authProvider.notifier).authState();
  final rootNavigatorKey = GlobalKey<NavigatorState>();
  final homeNavigatorKey = GlobalKey<NavigatorState>();
  final brandNavigatorKey = GlobalKey<NavigatorState>();
  return GoRouter(
      navigatorKey: rootNavigatorKey,
      observers: [BotToastNavigatorObserver(), CustomNavigationObserver()],
      initialLocation:  user==null? "/auth":"/home",

      routes: [

        StatefulShellRoute.indexedStack(
            builder: (context, state, navigator){
              return MainNavigationView(navigator: navigator);
            },
          branches: <StatefulShellBranch>[
            StatefulShellBranch(
              navigatorKey: homeNavigatorKey,

                routes: <RouteBase>[
                  GoRoute(
                      path: "/home",
                    name: RouteName.homeRoute,
                    builder: (context, state){
                        return HomeScreen();
                    }
                  )
                ]
            ),

            StatefulShellBranch(
                navigatorKey: brandNavigatorKey,

                routes: <RouteBase>[
                  GoRoute(
                      path: "/brand",
                      name: RouteName.brandRoute,
                      builder: (context, state){
                        return BrandScreen();
                      },
                    routes: [
                      GoRoute(
                          path: "create_brand",
                        name: RouteName.createBrandRoute,
                        pageBuilder: (context, state){

                            return CustomTransitionPage(
                              key: state.pageKey,
                                child: CreateBrand(),
                                transitionsBuilder: (context, anim, sanim,child){
                                return FadeTransition(opacity: anim, child: child,);
                                }
                            );

                        }
                      )
                    ]
                  )

                ]
            ),


            StatefulShellBranch(
                routes: <RouteBase>[
                  GoRoute(
                      path: "/settings",
                      name: RouteName.settingsRoute,
                      builder: (context, state){
                        return SettingsScreen();
                      },

                  )

                ]
            ),


          ],
        )


      ]
  );
});

class CustomNavigationObserver extends NavigatorObserver{

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print("Navigation status Pushed ${route.toString()}-${previousRoute.toString()}");
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    print("Navigation status Replaced ${newRoute.toString()}-${oldRoute.toString()}");
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print("Navigation status Removed ${route.toString()}-${previousRoute.toString()}");
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    print("Navigation status Popped ${route.toString()}-${previousRoute.toString()}");
  }

}