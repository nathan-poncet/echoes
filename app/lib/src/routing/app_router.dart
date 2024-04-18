import 'package:echoes/src/api/pocketbase.dart';
import 'package:echoes/src/common_widgets/data_display/icon/svg_icon.dart';
import 'package:echoes/src/features/account/presentation/account_screen.dart';
import 'package:echoes/src/features/echoes/presentation/echoes_screen.dart';
import 'package:echoes/src/features/echoes_discovered/presentation/echoes_discovered_screen.dart';
import 'package:echoes/src/features/home/presentation/home_screen.dart';
import 'package:echoes/src/routing/go_router_refresh_stream.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';

part 'app_router.g.dart';

enum AppRoute {
  home,
  echoes,
  discoveredEchoes,
  account,
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorEchoesKey = GlobalKey<NavigatorState>(debugLabel: 'echoes');
final _shellNavigatorDiscoveredEchoesKey = GlobalKey<NavigatorState>(debugLabel: 'discoveredEchoes');
final _shellNavigatorAccountKey = GlobalKey<NavigatorState>(debugLabel: 'account');

@Riverpod(keepAlive: true)
GoRouter goRouter(GoRouterRef ref) {
  final pocketBase = ref.watch(pocketBaseProvider);

  return GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/',
    navigatorKey: _rootNavigatorKey,
    redirect: (context, state) {
      final isLoggin = pocketBase.authStore.token != '';

      if (!isLoggin) {
        return '/';
      }

      if (state.fullPath == '/' && isLoggin) {
        return '/echoes';
      }
      return null;
    },
    refreshListenable: GoRouterRefreshStream(MergeStream([pocketBase.authStore.onChange])),
    routes: [
      GoRoute(path: '/', name: AppRoute.home.name, builder: (context, state) => const HomeScreen()),
      StatefulShellRoute.indexedStack(builder: (context, state, navigationShell) => ScaffoldWithNestedNavigation(navigationShell: navigationShell), branches: [
        StatefulShellBranch(navigatorKey: _shellNavigatorEchoesKey, routes: [
          GoRoute(
            path: '/echoes',
            name: AppRoute.echoes.name,
            builder: (context, state) => const EchoesScreen(),
          ),
        ]),
        StatefulShellBranch(navigatorKey: _shellNavigatorDiscoveredEchoesKey, routes: [
          GoRoute(
            path: '/discovered-echoes',
            name: AppRoute.discoveredEchoes.name,
            builder: (context, state) => const EchoesDiscoveredScreen(),
          ),
        ]),
        StatefulShellBranch(navigatorKey: _shellNavigatorAccountKey, routes: [
          GoRoute(
            path: '/account',
            name: AppRoute.account.name,
            builder: (context, state) => const AccountScreen(),
          ),
        ]),
      ])
    ],
  );
}

// Stateful nested navigation based on:
// https://github.com/flutter/packages/blob/main/packages/go_router/example/lib/stateful_shell_route.dart
class ScaffoldWithNestedNavigation extends StatelessWidget {
  const ScaffoldWithNestedNavigation({
    Key? key,
    required this.navigationShell,
  }) : super(key: key ?? const ValueKey('ScaffoldWithNestedNavigation'));
  final StatefulNavigationShell navigationShell;

  void _goBranch(int index) {
    navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        destinations: const [
          NavigationDestination(label: 'Discover', icon: Icon(Icons.map)),
          NavigationDestination(label: 'Archive', icon: SvgIcon("assets/icons/wave.svg")),
          NavigationDestination(label: 'Account', icon: Icon(Icons.account_circle)),
        ],
        onDestinationSelected: _goBranch,
      ),
    );
  }
}
