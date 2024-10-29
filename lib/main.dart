import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:raptorx/src/core/dependency_injection/dependency_injection.dart';
import 'package:raptorx/src/core/router/page_router.dart';
import 'package:raptorx/src/core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
    final appTheme = ref.watch(appThemeProvider);
    return FluentApp.router(
      title: 'Raptor-X',
      builder: BotToastInit(),
      themeMode: appTheme.mode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      color: appTheme.color,
      darkTheme: FluentThemeData(
        brightness: Brightness.dark,
        accentColor: appTheme.color,
        visualDensity: VisualDensity.standard,
        focusTheme: FocusThemeData(
          glowFactor: is10footScreen(context) ? 2.0 : 0.0,
        ),
      ),
      theme: FluentThemeData(
        accentColor: appTheme.color,
        visualDensity: VisualDensity.standard,
        focusTheme: FocusThemeData(
          glowFactor: is10footScreen(context) ? 2.0 : 0.0,
        ),
      ),
    );
  }
}
