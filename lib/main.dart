import 'dart:ui';

import 'package:flutter/material.dart';
import 'screens/catalog_screen.dart';
import 'screens/admin_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

class MouseTooScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}

Future<void> main() async {
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final CatalogRouterDelegate _routerDelegate = CatalogRouterDelegate();
  final CatalogRouteInformationParser _routeInformationParser = CatalogRouteInformationParser();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      scrollBehavior: MouseTooScrollBehavior(),
      title: 'Katalog CSM',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerDelegate: _routerDelegate,
      routeInformationParser: _routeInformationParser,
    );
  }
}

class CatalogRouteInformationParser  extends RouteInformationParser<CatalogRoutePath> {
  @override
  Future<CatalogRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = routeInformation.uri;
    // Handle '/admin/'
    if (uri.pathSegments.length == 1) {
      return CatalogRoutePath.admin();
    }
  // Handle unknown routes and '/'
    return CatalogRoutePath.catalog();
  }

  @override
  RouteInformation restoreRouteInformation(CatalogRoutePath configuration) {
    if (configuration.isAdminPage) {
      return RouteInformation(uri: Uri.parse('/admin'));
    }
    return RouteInformation(uri: Uri.parse('/'));
  }
}

class CatalogRouterDelegate  extends RouterDelegate<CatalogRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<CatalogRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  bool isCatalog = true;
  CatalogRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  @override
  CatalogRoutePath get currentConfiguration {
    return isCatalog == true
        ? CatalogRoutePath.catalog()
        : CatalogRoutePath.admin();
  }

  List<Page> get _catalogStack {

    return [MaterialPage(
      key: const ValueKey('CatalogPage'),
      child: CatalogScreen(),
    ),];
  }

  List<Page> get _adminStack {

    return [const MaterialPage(
      key: ValueKey('AdminPage'),
      child: AdminScreen(),
    ),];
  }

  @override
  Widget build(BuildContext context) {
    List<Page> stack;
    if (isCatalog == true) {
      stack = _catalogStack;
    } else {
      stack = _adminStack;
    }
    return Navigator(
      key: navigatorKey,
      pages: stack,
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;
        isCatalog = true;
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(CatalogRoutePath configuration) async {
    isCatalog = configuration.isCatalog;
  }
}

class CatalogRoutePath {
  final bool isCatalog;

  CatalogRoutePath.catalog(): isCatalog = true;
  CatalogRoutePath.admin(): isCatalog = false;

  bool get isCatalogPage => isCatalog;
  bool get isAdminPage => !isCatalog;
}