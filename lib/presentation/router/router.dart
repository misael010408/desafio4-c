import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../main.dart';

// Control sencillo de sesión
class AuthNotifier extends ChangeNotifier {
  bool estaLogueado = false;

  void login() {
    estaLogueado = true;
    notifyListeners();
  }

  void logout() {
    estaLogueado = false;
    notifyListeners();
  }
}

final authNotifier = AuthNotifier();

final appRouter = GoRouter(
  initialLocation: '/login',
  refreshListenable: authNotifier,
  redirect: (context, state) {
    final estaEnLogin = state.matchedLocation == '/login';

    if (!authNotifier.estaLogueado && !estaEnLogin) {
      return '/login';
    }

    if (authNotifier.estaLogueado && estaEnLogin) {
      return '/';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) {
        return AppShell(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/posts',
          builder: (context, state) {
            final busqueda = state.uri.queryParameters['search'] ?? '';
            return PostsScreen(busqueda: busqueda);
          },
          routes: [
            GoRoute(
              path: ':id',
              builder: (context, state) {
                final id = int.parse(state.pathParameters['id']!);
                return DetailScreen(postId: id);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);

// Menú inferior compartido
class AppShell extends StatelessWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    int seccion = 0;

    if (location.startsWith('/posts')) {
      seccion = 1;
    }
    if (location.startsWith('/profile')) {
      seccion = 2;
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: seccion,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go('/');
              break;
            case 1:
              context.go('/posts');
              break;
            case 2:
              context.go('/profile');
              break;
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.article_outlined),
            label: 'Posts',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}