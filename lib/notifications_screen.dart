import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const Color kPrimaryColor = Color(0xFF27A4A7);
const Color kDarkText = Color(0xFF1B1B1B);
const Color kGreyText = Color(0xFF757575);

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              colors: [
                Color.from(alpha: 1, red: 0.89, green: 0.957, blue: 0.965),
                Color.fromARGB(255, 162, 234, 236),
              ],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(context),

                  const SizedBox(height: 30),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'الحدث',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: kDarkText,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildAchievementCard(),

                  const SizedBox(height: 24),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'الإشعارات',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: kDarkText,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildNotificationsList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              const Text(
                'الإنجازات والإشعارات',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: kDarkText,
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  size: 20,
                  color: kDarkText,
                ),

                onPressed: () => context.pop(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'لإكمال الهدف "تعلم الفرنسية"',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: kDarkText,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'بنسبة 110%!',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: kPrimaryColor,
                  ),
                ),
              ],
            ),
          ),

          Image.asset(
            'assets/images/atten.png',
            width: 40,
            height: 40,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList() {
    //   temp data
    final List<Map<String, dynamic>> notifications = [
      {
        'title': 'تم اكتمال الهدف "تعلم الفرنسية"',
        'subtitle': 'بنسبة 110%',
        'date': 'المنذ يومين',
        'icon': Icons.check_circle,
        'iconColor': kPrimaryColor,
      },
      {
        'title': 'تحديث المحتوى لإنجاز الهدف الفرنسية الضروري',
        'subtitle': 'المنذ يومين',
        'icon': Icons.sync, // Icons.refresh
        'iconColor': kPrimaryColor,
      },
      {
        'title': 'نسبة الأهداف الكبرى التحديث الحالية',
        'subtitle': 'المنذ يومين',
        'icon': Icons.star,
        'iconColor': kPrimaryColor,
      },
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: notifications.asMap().entries.map((entry) {
          int index = entry.key;
          var item = entry.value;
          return Column(
            children: [
              _buildNotificationItem(
                title: item['title'],
                subtitle: item['subtitle'],
                icon: item['icon'],
                iconColor: item['iconColor'],
              ),
              //  divider
              if (index < notifications.length - 1)
                const Divider(
                  color: Color(0xFFEEEEEE),
                  height: 1,
                  thickness: 1,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNotificationItem({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFE3F4F6),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(width: 12),

          // text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: kDarkText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 13, color: kGreyText),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
