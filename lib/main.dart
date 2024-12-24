// The original content is temporarily commented out to allow generating a self-contained demo - feel free to uncomment later.

import 'package:bot_toast/bot_toast.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raptorx/src/config/theme/theme.dart';
import 'package:raptorx/src/core/dependency_injection/dependency_injection.dart';
import 'package:raptorx/src/core/router/page_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupService();
  runApp(UncontrolledProviderScope(
    container: container,
    child: const MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return FluentApp.router(
      title: 'Raptor-X',
      builder: BotToastInit(),
      themeMode: ThemeMode.dark,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      theme: RaptorThemeData.myFluentTheme,
    );
  }
}
