import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RafiqLoginScreen extends StatefulWidget {
  const RafiqLoginScreen({super.key});

  @override
  State<RafiqLoginScreen> createState() => _RafiqLoginScreenState();
}

class _RafiqLoginScreenState extends State<RafiqLoginScreen> {
  // متغيرات التحكم في حقول الإدخال
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // متغير لإخفاء / إظهار كلمة المرور
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF27A4A7);

    return Scaffold(
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl, // اتجاه النص من اليمين لليسار
          child: SingleChildScrollView(
            // نستخدم SingleChildScrollView لتفادي مشكلة ظهور لوحة المفاتيح واختفاء الحقول
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),

                  // 1. الشعار
                  Column(
                    children: [
                      SizedBox(
                        height: 80,
                        width: 80,
                        // ضع مسار صورة الشعار الخاصة بك هنا
                        child: Image.asset(
                          'assets/images/logodd.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'رفيق',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1B1B1B),
                        ),
                      ),
                      const Text(
                        'RAFIQ',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 50),

                  // 2. عنوان الصفحة
                  const Text(
                    'تسجيل الدخول',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1B1B1B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'أهلاً بك مجدداً، يرجى إدخال بياناتك.',
                    style: TextStyle(fontSize: 16, color: Color(0xFF757575)),
                  ),

                  const SizedBox(height: 40),

                  // 3. حقل اسم المستخدم
                  TextFormField(
                    controller: _usernameController,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      labelText: 'اسم المستخدم أو البريد الإلكتروني',
                      labelStyle: const TextStyle(color: Color(0xFF757575)),
                      prefixIcon: const Icon(
                        Icons.person_outline,
                        color: primaryColor,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: primaryColor,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 18,
                        horizontal: 20,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 4. حقل كلمة المرور
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible, // التحكم في الإخفاء
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      labelText: 'كلمة المرور',
                      labelStyle: const TextStyle(color: Color(0xFF757575)),
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: primaryColor,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: const Color(0xFF757575),
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: primaryColor,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 18,
                        horizontal: 20,
                      ),
                    ),
                  ),

                  // 5. زر "نسيت كلمة المرور"
                  Align(
                    alignment: Alignment
                        .centerLeft, // يظهر على اليسار (أي يمين الشاشة في RTL)
                    child: TextButton(
                      onPressed: () {
                        // ضع منطق استعادة كلمة المرور هنا
                      },
                      child: const Text(
                        'نسيت كلمة المرور؟',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 6. زر تسجيل الدخول
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: () {
                        // ضع منطق التحقق من البيانات وتسجيل الدخول هنا
                        final username = _usernameController.text.trim();
                        final password = _passwordController.text.trim();
                        if (username.isNotEmpty && password.isNotEmpty) {
                          // نف الدخول...
                          context.go('/home');
                        }
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

                  const SizedBox(height: 40),

                  // 7. زر إنشاء حساب جديد (إذا لم يكن لديك حساب)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'ليس لديك حساب؟ ',
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF757575),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // ضع منطق الانتقال لصفحة إنشاء حساب جديد هنا
                        },
                        child: const Text(
                          'إنشاء حساب جديد',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                            decoration: TextDecoration.underline,
                            decorationColor: primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
