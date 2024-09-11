import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/router/go_router.dart';
import '../core/theme/theme.dart';
import '../core/utils/locale_manager.dart';
import '../l10n/strings.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
  static _AppState of(BuildContext context) =>
      context.findAncestorStateOfType<_AppState>()!;
  static AppTheme appTheme(BuildContext context) => of(context)._appTheme;
}

class _AppState extends State<App> {
  AppTheme _appTheme = AppTheme.defaultTheme;
  late GoRouter _router;

  final localeManager = LocaleManager();

  void toggleTheme() {
    final newType = _appTheme.type == ThemeType.lightOrange
        ? ThemeType.darkOrange
        : ThemeType.lightOrange;

    _appTheme = AppTheme.fromType(newType);
  }

  bool get isLocaleSet => localeManager.isLocaleSet;
  Locale get locale => localeManager.locale;
  void setLocale(Locale newLocale) async {
    localeManager.locale = newLocale;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    localeManager.initLocale();
    _router = buildRouter(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: MaterialApp.router(
        theme: _appTheme.themeData,
        debugShowCheckedModeBanner: false,
        onGenerateTitle: (context) => Strings.of(context).appName,
        routerDelegate: _router.routerDelegate,
        routeInformationParser: _router.routeInformationParser,
        routeInformationProvider: _router.routeInformationProvider,
        supportedLocales: Strings.supportedLocales,
        localizationsDelegates: Strings.localizationsDelegates,
        locale: localeManager.locale,
      ),
    );
  }
}
