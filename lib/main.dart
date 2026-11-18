import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'presentation/router/router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Desafío 4C',
      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),
      routerConfig: appRouter,
    );
  }
}

// LOGIN
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar sesión')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            authNotifier.login();
          },
          child: const Text('Ingresar'),
        ),
      ),
    );
  }
}

// INICIO
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inicio')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.home, size: 80),
            const Text(
              'Bienvenido a mi aplicación',
              style: TextStyle(fontSize: 22),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/posts'),
              child: const Text('Ver publicaciones'),
            ),
            TextButton(
              onPressed: () => authNotifier.logout(),
              child: const Text('Cerrar sesión'),
            ),
          ],
        ),
      ),
    );
  }
}

// PUBLICACIONES
class PostsScreen extends StatelessWidget {
  final String busqueda;

  const PostsScreen({
    super.key,
    this.busqueda = '',
  });

  @override
  Widget build(BuildContext context) {
    final posts = [
      'Aprendiendo Flutter',
      'Programación en Dart',
      'Desarrollo de aplicaciones',
      'Diseño de interfaces',
    ];

    final filtrados = posts
        .asMap()
        .entries
        .where((e) => e.value.toLowerCase().contains(busqueda.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Publicaciones'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              context.go('/posts?search=flutter');
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filtrados.length,
        itemBuilder: (context, index) {
          final post = filtrados[index];

          return ListTile(
            leading: const Icon(Icons.article),
            title: Text(post.value),
            subtitle: Text('Publicación ${post.key + 1}'),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              context.push('/posts/${post.key + 1}');
            },
          );
        },
      ),
    );
  }
}

// DETALLE
class DetailScreen extends StatelessWidget {
  final int postId;

  const DetailScreen({
    super.key,
    required this.postId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle')),
      body: Center(
        child: Text(
          'Estás viendo la publicación número $postId',
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

// PERFIL
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_circle, size: 90),
            Text(
              'Mi perfil',
              style: TextStyle(fontSize: 22),
            ),
          ],
        ),
      ),
    );
  }
}