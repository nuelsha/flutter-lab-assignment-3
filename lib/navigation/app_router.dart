import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import '../presentation/screens/album_list_screen.dart';
import '../presentation/screens/album_detail_screen.dart';
import '../data/models/album.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const AlbumListScreen(),
        routes: [
          GoRoute(
            path: 'album/:id',
            builder: (context, state) {
              final album = state.extra as Album?;
              return AlbumDetailScreen(album: album);
            },
          ),
        ],
      ),
    ],
  );
} 