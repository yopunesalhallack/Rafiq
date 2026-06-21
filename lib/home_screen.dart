import 'package:flutter/material.dart';

// الألوان الخاصة بالهوية البصرية
const Color kPrimaryColor = Color(0xFF27A4A7);
const Color kDarkText = Color(0xFF1B1B1B);
const Color kGreyText = Color(0xFF757575);
const Color kLightBackground = Color(0xFFF6FAFB);
const Color kProgressGreen = Color(0xFF4CB6B6);
const Color kProgressOrange = Color(0xFFF5A623);

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // تفعيل اتجاه النص من اليمين لليسار
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          // 2. تطبيق التدرج اللوني هنا
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft, // يبدأ من الأعلى
              end: Alignment.topRight, // ينتهي في الأسفل
              colors: [
                Color.from(
                  alpha: 1,
                  red: 0.89,
                  green: 0.957,
                  blue: 0.965,
                ), // لون سماوي فاتح جداً في الأعلى (يعبر عن هوية التطبيق)
                Color.fromARGB(255, 162, 234, 236), // لون أبيض نقي في الأسفل
              ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  // 3. رأس الصفحة (Header) - تمت إزالة خلفيته الصلبة ليظهر التدرج من خلفه
                  _buildHeader(),

                  const SizedBox(height: 20),

                  // 4. بطاقة تقدم اليوم
                  _buildProgressCard(),

                  const SizedBox(height: 24),

                  // 5. قسم مهام اليوم
                  _buildTaskSection(),

                  const SizedBox(height: 24),

                  // 6. بطاقة AI Tip
                  _buildAITipCard(),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),

        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: kPrimaryColor,
          unselectedItemColor: kGreyText,
          currentIndex: 0, // الصفحة الحالية هي الرئيسية
          elevation: 10,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'الرئيسية',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.flag_outlined),
              label: 'الأهداف',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.smart_toy_outlined),
              label: 'المساعد',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'الملف الشخصي',
            ),
          ],
        ),
      ),
    );
  }

  // --- أقسام الصفحة ---

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: const BoxDecoration(),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'مرحباً أحمد!',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: kDarkText,
            ),
          ),
          // أيقونة الإشعارات
          Stack(
            children: [
              const Icon(
                Icons.notifications_outlined,
                size: 30,
                color: kPrimaryColor,
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildProgressCircle(0.75, '75%', 'تقدم اليوم', kPrimaryColor),
          _buildProgressCircle(0.75, '12/16', 'المهام المنجزة', kProgressGreen),
          _buildProgressCircle(
            0.55,
            '55%',
            'نسبة للأهداف القادرة',
            kProgressOrange,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCircle(
    double value,
    String text,
    String label,
    Color color,
  ) {
    return Column(
      children: [
        SizedBox(
          width: 70,
          height: 70,
          child: Stack(
            children: [
              // حلقة خلفية رمادية فاتحة
              Center(
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    value: 1.0,
                    strokeWidth: 6,
                    color: Colors.grey[200],
                  ),
                ),
              ),
              // حلقة التقدم الملونة
              Center(
                child: SizedBox(
                  width: 60,
                  height: 60,
                  child: CircularProgressIndicator(
                    value: value,
                    strokeWidth: 6,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    strokeCap: StrokeCap.round,
                  ),
                ),
              ),
              // النص في المنتصف
              Center(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: kDarkText,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: kGreyText,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildTaskSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // عنوان القسم وزر "المزيد"
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'مهام اليوم',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: kDarkText,
                ),
              ),
              Text(
                'المزيد',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: kPrimaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // المهمة الأولى
          _buildTaskItem('مراجعة عرض المشروع', 0.45, true),
          const SizedBox(height: 12),

          // المهمة الثانية
          _buildTaskItem('تدريب رياضي', 0.45, false),
        ],
      ),
    );
  }

  Widget _buildTaskItem(String title, double progress, bool isChecked) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: kDarkText,
                ),
              ),
              Row(
                children: [
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: kPrimaryColor,
                    ),
                  ),
                  const SizedBox(width: 10),
                  // مربع الاختيار
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isChecked ? kPrimaryColor : Colors.transparent,
                      border: Border.all(
                        color: isChecked ? kPrimaryColor : Colors.grey[400]!,
                        width: 2,
                      ),
                    ),
                    child: isChecked
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : null,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          // شريط التقدم
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(kPrimaryColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAITipCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.arrow_back_ios_new, size: 16, color: kPrimaryColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Text(
                      'AI Tip',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: kDarkText,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.auto_awesome, size: 18, color: kPrimaryColor),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'مساعدك الذكي لإنجاز أهدافك وتنظيم حياتك.',
                  style: TextStyle(fontSize: 14, color: kGreyText, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
