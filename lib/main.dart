import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rafiq_app/assistant_screen.dart';
import 'package:rafiq_app/core/utils/locale_provider.dart';
//import 'package:rafiq_app/core/utils/service_locator.dart';
import 'package:rafiq_app/features/auth/presentation/screens/login_screen.dart';
import 'package:rafiq_app/features/goals/presentation/screens/goal_details_screen.dart';
import 'package:rafiq_app/features/goals/presentation/screens/goals_screen.dart';
import 'package:rafiq_app/features/tasks/presentation/screens/onboarding_screen.dart';
import 'package:rafiq_app/home_screen.dart';
import 'package:rafiq_app/l10n/app_localizations.dart';
import 'package:rafiq_app/notifications_screen.dart';
import 'package:rafiq_app/profile_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const ProviderScope(child: RafiqApp()));
}

///////////routes/////////
final _router = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    // GoRoute(path: '/goals', builder: (context, state) => GoalsScreen()),
    GoRoute(
      path: '/goal-details',
      builder: (context, state) => const GoalDetailsScreen(),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(path: '/home', builder: (context, state) => HomeScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(path: '/goals', builder: (context, state) => GoalsScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/assistant',
              builder: (context, state) => const AssistantScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);

class RafiqApp extends ConsumerWidget {
  const RafiqApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider); // cuurent lang

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,

      title: 'Rafiq App',
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'SA'), // العربية
        Locale('en', 'US'), // الإنجليزية
      ],
      theme: ThemeData(
        primaryColor: const Color(0xFF27A4A7),
        scaffoldBackgroundColor: Colors.white,
        useMaterial3: true,
      ),
    );
  }
}

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF27A4A7),
        unselectedItemColor: const Color(0xFF757575),
        currentIndex: navigationShell.currentIndex, // index
        elevation: 10,
        selectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        onTap: (int index) {
          navigationShell.goBranch(index);
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_filled),
            label: l10n.nav_home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.flag_outlined),
            label: l10n.nav_goals,
          ),
          BottomNavigationBarItem(
            icon: SizedBox(
              width: 26,
              height: 26,
              child: Image.asset(
                'assets/images/logogd.png',
                fit: BoxFit.contain,
              ),
            ),
            label: l10n.nav_assistant,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.person_outline),
            label: l10n.nav_profile,
          ),
        ],
      ),
    );
  }
}

@override
Widget build(BuildContext context) {
  const primaryColor = Color(0xFF27A4A7);

  return Scaffold(
    body: SafeArea(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  Container(
                    height: 100,
                    width: 100,
                    margin: const EdgeInsets.only(top: 30),
                    child: Image.asset('assets/images/logodd.png'),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'رفيق',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF27A4A7),
                    ),
                  ),
                  const Text(
                    'RAFIQ',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF27A4A7),
                    ),
                  ),
                ],
              ),

              const Spacer(),
              Container(
                height: 300,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Image.asset('assets/images/onboarding_r.png'),
              ),

              const Spacer(),

              const Text(
                'أهلاً بك في رفيق!',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B1B1B),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'مساعدك الذكي لإنجاز أهدافك وتنظيم حياتك.',
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF757575),
                  height: 1.5, //
                ),
                textAlign: TextAlign.center,
              ),

              const Spacer(flex: 2),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    context.go('/login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'تسجيل الدخول',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: OutlinedButton(
                  onPressed: () {
                    // sigm up screen
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: primaryColor, width: 1.5),
                    foregroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'إنشاء حساب جديد',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    ),
  );
}
