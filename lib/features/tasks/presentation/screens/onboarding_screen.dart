import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

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
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: OutlinedButton(
                    onPressed: () {
                      // create acounte later after add Ai agent
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
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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
}
