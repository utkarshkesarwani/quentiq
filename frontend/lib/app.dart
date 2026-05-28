import 'package:flutter/material.dart';
import 'package:quentiq/core/theme/app_theme.dart';
import 'package:quentiq/features/auth/login_screen.dart';
import 'package:quentiq/features/complaint/complaint_tracking_screen.dart';
import 'package:quentiq/features/complaint/raise_complaint_screen.dart';
import 'package:quentiq/features/manager/ai_insights_screen.dart';
import 'package:quentiq/features/manager/complaint_queue_screen.dart';
import 'package:quentiq/features/manager/manager_dashboard_screen.dart';
import 'package:quentiq/features/notifications/notifications_screen.dart';
import 'package:quentiq/features/resident/resident_home_screen.dart';
import 'package:quentiq/features/splash/splash_screen.dart';
import 'package:quentiq/routes/app_routes.dart';

class QuentiqApp extends StatefulWidget {
  const QuentiqApp({super.key});

  @override
  State<QuentiqApp> createState() => _QuentiqAppState();
}

class _QuentiqAppState extends State<QuentiqApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quentiq',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: _themeMode,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: (settings) {
        Widget page;
        switch (settings.name) {
          case AppRoutes.splash:
            page = const SplashScreen();
          case AppRoutes.login:
            page = const LoginScreen();
          case AppRoutes.home:
            page = _ThemeToggleWrapper(
              onToggle: _toggleTheme,
              child: const ResidentHomeScreen(),
            );
          case AppRoutes.raiseComplaint:
            final voice = settings.arguments == true;
            page = RaiseComplaintScreen(startWithVoice: voice);
          case AppRoutes.complaintTracking:
            page = const ComplaintTrackingScreen();
          case AppRoutes.notifications:
            page = const NotificationsScreen();
          case AppRoutes.managerDashboard:
            page = _ThemeToggleWrapper(
              onToggle: _toggleTheme,
              child: const ManagerDashboardScreen(),
            );
          case AppRoutes.complaintQueue:
            page = const ComplaintQueueScreen();
          case AppRoutes.aiInsights:
            page = const AiInsightsScreen();
          default:
            page = const SplashScreen();
        }
        return MaterialPageRoute(builder: (_) => page, settings: settings);
      },
    );
  }
}

class _ThemeToggleWrapper extends StatelessWidget {
  const _ThemeToggleWrapper({
    required this.child,
    required this.onToggle,
  });

  final Widget child;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Positioned(
          top: MediaQuery.paddingOf(context).top + 4,
          right: 8,
          child: IconButton(
            onPressed: onToggle,
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
              size: 22,
            ),
            tooltip: 'Toggle theme',
          ),
        ),
      ],
    );
  }
}
