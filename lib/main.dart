import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'routing/app_router.dart';
import 'services/content_service.dart';
import 'theme/app_theme.dart';

/// Global dark-mode notifier. Settings screen writes to this;
/// TpogApp rebuilds MaterialApp when it changes.
final ValueNotifier<bool> darkModeNotifier = ValueNotifier<bool>(false);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ContentService.instance.load();
  ContentService.instance.startPolling();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
    ),
  );
  runApp(const TpogApp());
}

class TpogApp extends StatelessWidget {
  const TpogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: darkModeNotifier,
      builder: (context, isDark, _) {
        return MaterialApp.router(
          title: 'The Place of Grace',
          debugShowCheckedModeBanner: false,
          theme: isDark ? ThemeData.dark(useMaterial3: true) : AppTheme.light(),
          routerConfig: appRouter,
        );
      },
    );
  }
}
