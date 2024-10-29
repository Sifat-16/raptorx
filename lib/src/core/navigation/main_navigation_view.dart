import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:raptorx/src/core/navigation/navigation_controller.dart';
import 'package:raptorx/src/core/router/page_router.dart';
import 'package:raptorx/src/core/router/route_name.dart';
import 'package:raptorx/src/features/brand/brands/presentation/view/brand_screen.dart';
import 'package:raptorx/src/features/brand/create_brand/presentation/view/create_brand.dart';

import 'package:raptorx/src/features/home/presentation/view/home_screen.dart';
import 'package:raptorx/src/features/home/presentation/view/navigator/home_navigator.dart';
import 'package:raptorx/src/features/settings/presentation/view/settings_screen.dart';


class MainNavigationView extends ConsumerStatefulWidget {
  const MainNavigationView({super.key, required this.navigator});
  final StatefulNavigationShell navigator;
  @override
  ConsumerState<MainNavigationView> createState() => _MainNavigationViewState();
}

class _MainNavigationViewState extends ConsumerState<MainNavigationView> {
  @override
  Widget build(BuildContext context) {
    final navigationController = ref.watch(navigationProvider);
    final router = ref.watch(goRouterProvider);

    return NavigationView(
      
        appBar:  NavigationAppBar(
          title: Text('Raptor-X'),
          automaticallyImplyLeading: false,

          leading: GestureDetector(
            onTap: (){


              if(router.canPop()){

                router.pop();
              }else{

              }

            },
            child: Icon(FluentIcons.back),
          )

        ),


      pane: NavigationPane(

          selected: navigationController.topIndex,
          onChanged: ref.read(navigationProvider.notifier).updateTopIndex,
          displayMode: PaneDisplayMode.open,

        items: [
          PaneItem(
            key: ValueKey(RouteName.homeRoute),
            icon: const Icon(FluentIcons.home),
            title: const Text('Home'),
            body: HomeScreen(),
          ),

          // PaneItem(
          //   key: ValueKey(RouteName.homeRoute),
          //   icon: const Icon(FluentIcons.account_management),
          //   title: const Text('Brand'),
          //   body: BrandScreen(),
          // ),
          PaneItemExpander(
              icon: const Icon(FluentIcons.account_management),
              title: const Text('Brand'),
              body: BrandScreen(),
              items: [
                // PaneItemHeader(
                //     header: const Text(''),
                // ),
                PaneItem(
                  icon: const Icon(FluentIcons.mail),
                  title: const Text('Create Brand'),
                  body: CreateBrand(),

                ),

              ],
            ),

        ],

        footerItems: [
          PaneItem(
            icon: const Icon(FluentIcons.settings),
            title: const Text('Settings'),
            body: const SettingsScreen(),
            onTap: () {
              if (GoRouterState.of(context).uri.toString() != '/settings') {
                context.go('/settings');
              }
            },
          ),
        ]
      ),
    );
  }
}


// class NavigationPanelItems{
//
//   List<NavigationPaneItem> items = [
//     PaneItem(
//       icon: const Icon(FluentIcons.home),
//       title: const Text('Home'),
//       body: const HomeBodyItem(),
//     ),
//     PaneItemSeparator(),
//     PaneItem(
//       icon: const Icon(FluentIcons.issue_tracking),
//       title: const Text('Brands'),
//       //infoBadge: const InfoBadge(source: Text('8')),
//       body: BrandNavigator(),
//     ),
//     PaneItem(
//       icon: const Icon(FluentIcons.disable_updates),
//       title: const Text('Disabled Item'),
//       body: const _NavigationBodyItem(),
//       enabled: false,
//     ),
//     PaneItemExpander(
//       icon: const Icon(FluentIcons.account_management),
//       title: const Text('Account'),
//       body: const _NavigationBodyItem(
//         header: 'PaneItemExpander',
//         content: Text(
//           'Some apps may have a more complex hierarchical structure '
//               'that requires more than just a flat list of navigation '
//               'items. You may want to use top-level navigation items to '
//               'display categories of pages, with children items displaying '
//               'specific pages. It is also useful if you have hub-style '
//               'pages that only link to other pages. For these kinds of '
//               'cases, you should create a hierarchical NavigationView.',
//         ),
//       ),
//       items: [
//         PaneItemHeader(header: const Text('Apps')),
//         PaneItem(
//           icon: const Icon(FluentIcons.mail),
//           title: const Text('Mail'),
//           body: const _NavigationBodyItem(),
//         ),
//         PaneItem(
//           icon: const Icon(FluentIcons.calendar),
//           title: const Text('Calendar'),
//           body: const _NavigationBodyItem(),
//         ),
//       ],
//     ),
//     PaneItemWidgetAdapter(
//       child: Builder(builder: (context) {
//         // Build the widget depending on the current display mode.
//         //
//         // This already returns the resolved auto display mode.
//         if (NavigationView.of(context).displayMode == PaneDisplayMode.compact) {
//           return const FlutterLogo();
//         }
//         return ConstrainedBox(
//           // Constraints are required for top display mode, otherwise the Row will
//           // expand to the available space.
//           constraints: const BoxConstraints(maxWidth: 200.0),
//           child: const Row(children: [
//             FlutterLogo(),
//             SizedBox(width: 6.0),
//             Text('This is a custom widget'),
//           ]),
//         );
//       }),
//     ),
//   ];
//
//   List<NavigationPaneItem> footer = [
//     PaneItem(
//       icon: const Icon(FluentIcons.settings),
//       title: const Text('Settings'),
//       body: const SettingsScreen(),
//     ),
//   ];
//
// }
class _NavigationBodyItem extends StatelessWidget {
  const _NavigationBodyItem({
    this.header,
    this.content,
  });

  final String? header;
  final Widget? content;

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage.withPadding(
      header: PageHeader(title: Text(header ?? 'This is a header text')),
      content: content ?? const SizedBox.shrink(),
    );
  }
}