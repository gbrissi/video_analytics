import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_analytics/screens/photo_albums_screen.dart';
import 'package:video_analytics/screens/video_select_screen.dart';
import 'package:video_analytics/screens/view_album_screen.dart';
import 'package:video_analytics/widgets/shell.dart';

// TODO: Must update GoRouter to a newer version, a known issue was affecting the transition speed on new pages rendering.
CustomTransitionPage buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionDuration: Duration.zero,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}

final GoRouter router = GoRouter(
  initialLocation: "/convert",
  routes: <RouteBase>[
    ShellRoute(
      builder: (context, state, child) {
        return Shell(
          child: child,
        );
      },
      routes: [
        GoRoute(
          path: '/convert',
          name: "Convert",
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const VideoSelectScreen(),
          ),
        ),
        GoRoute(
          path: '/album',
          name: "Album",
          pageBuilder: (context, state) => buildPageWithDefaultTransition(
            context: context,
            state: state,
            child: const PhotoAlbumsScreen(),
          ),
          routes: [
            GoRoute(
              path: 'view',
              name: "ViewAlbum",
              pageBuilder: (context, state) => buildPageWithDefaultTransition(
                context: context,
                state: state,
                child: ViewAlbumScreen(
                  album: (state.extra as Map<String, dynamic>)["directory"],
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  ],
);
