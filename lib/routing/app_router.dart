import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/forgot_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/register_screen.dart';
import '../features/chat/chat_screen.dart';
import '../features/community/community_screen.dart';
import '../features/donate/donate_screen.dart';
import '../features/events/events_screen.dart';
import '../features/exhibitors/exhibitors_screen.dart';
import '../features/grace/grace_screen.dart';
import '../features/home/home_screen.dart';
import '../features/media/media_screen.dart';
import '../features/members/members_screen.dart';
import '../features/more/more_screen.dart';
import '../features/notes/notes_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/request/requests_screen.dart';
import '../features/schedule/schedule_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/shell/app_shell.dart';
import '../features/social_media/social_media_screen.dart';
import '../features/vod/watch_screen.dart';

final _shellKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  initialLocation: '/auth/login',
  routes: [
    GoRoute(
      path: '/',
      redirect: (_, __) => '/auth/login',
    ),
    GoRoute(
      path: '/auth/login',
      builder: (_, __) => const LoginScreen(),
    ),
    GoRoute(
      path: '/auth/register',
      builder: (_, __) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/auth/forgot',
      builder: (_, __) => const ForgotScreen(),
    ),
    StatefulShellRoute.indexedStack(
      parentNavigatorKey: _shellKey,
      builder: (_, __, shell) => AppShell(shell: shell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
                path: '/community',
                builder: (_, __) => const CommunityScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/events', builder: (_, __) => const EventsScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/chat', builder: (_, __) => const ChatScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/more', builder: (_, __) => const MoreScreen()),
          ],
        ),
      ],
    ),
    GoRoute(path: '/grace', builder: (_, __) => const GraceScreen()),
    GoRoute(path: '/notes', builder: (_, __) => const NotesScreen()),
    GoRoute(path: '/donate', builder: (_, __) => const DonateScreen()),
    GoRoute(path: '/media', builder: (_, __) => const MediaScreen()),
    GoRoute(path: '/watch', builder: (_, __) => const WatchScreen()),
    GoRoute(path: '/schedule', builder: (_, __) => const ScheduleScreen()),
    GoRoute(path: '/members', builder: (_, __) => const MembersScreen()),
    GoRoute(path: '/profile', builder: (_, __) => const ProfileScreen()),
    GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
    GoRoute(path: '/social', builder: (_, __) => const SocialMediaScreen()),
    GoRoute(path: '/exhibitors', builder: (_, __) => const ExhibitorsScreen()),
    GoRoute(path: '/requests', builder: (_, __) => const RequestsScreen()),
  ],
);
