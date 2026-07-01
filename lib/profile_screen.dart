import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // ✅ إضافة Riverpod
import 'package:go_router/go_router.dart';
import 'package:rafiq_app/core/utils/locale_provider.dart';

import 'package:rafiq_app/home_screen.dart';
import 'package:rafiq_app/l10n/app_localizations.dart';

// الثوابت
const Color kPrimaryColor = Color(0xFF27A4A7);
const Color kDarkText = Color(0xFF1B1B1B);
const Color kGreyText = Color(0xFF757575);

class ProfileScreen extends ConsumerWidget {
  // ✅ تحويل إلى ConsumerWidget
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // مراقبة الإحصائيات
    final statsAsync = ref.watch(statsProvider);
    final locale = ref.watch(localeProvider);
    final isArabic = locale.languageCode == 'ar';
    final l10n = AppLocalizations.of(context)!;

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
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
              child: Column(
                children: [
                  _buildProfileHeader(l10n),
                  const SizedBox(height: 24),

                  // ✅ استخدام AsyncValue.when للتعامل مع الإحصائيات
                  statsAsync.when(
                    data: (stats) {
                      final completedTasks = stats['completedTasks'] as int;
                      final totalGoals = stats['totalGoals'] as int;
                      final completedGoals = stats['completedGoals'] as int;
                      final activeGoals =
                          totalGoals -
                          completedGoals; // الأهداف النشطة = الإجمالي - المكتملة

                      return _buildStatsRow(
                        l10n: l10n,
                        completedTasks: completedTasks,
                        activeGoals: activeGoals,
                        completedGoals: completedGoals,
                      );
                    },
                    loading: () => const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    error: (err, stack) =>
                        Center(child: Text('خطأ في تحميل الإحصائيات: $err')),
                  ),

                  const SizedBox(height: 30),
                  _buildSettingsList(context, ref, l10n),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(AppLocalizations l10n) {
    // ... (بقية الكود كما هو، بدون تغيير)
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: Colors.orangeAccent,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, size: 50, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.profile_name,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: kDarkText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  l10n.profile_email,
                  style: const TextStyle(fontSize: 14, color: kGreyText),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: kPrimaryColor, width: 1),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.edit_outlined,
                        size: 14,
                        color: kPrimaryColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        l10n.profile_edit,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: kPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ✅ تم تحديث الدالة لتستقبل القيم الحقيقية
  Widget _buildStatsRow({
    required AppLocalizations l10n,

    required int completedTasks,
    required int activeGoals,
    required int completedGoals,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          _buildStatItem('$completedTasks', l10n.stats_tasks_completed),
          const SizedBox(width: 12),
          _buildStatItem('$activeGoals', l10n.stats_goals_active),
          const SizedBox(width: 12),
          _buildStatItem('$completedGoals', l10n.stats_goals_completed),
        ],
      ),
    );
  }

  // ... (بقية الدوال كما هي، لم تتغير)
  Widget _buildStatItem(String number, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.08),
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              number,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: kPrimaryColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: kGreyText),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsList(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) {
    final currentLanguage = ref.watch(localeProvider).languageCode == 'ar'
        ? l10n.dialog_arabic
        : l10n.dialog_english;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          _buildMenuItem(
            icon: Icons.person_outline,
            title: l10n.settings_personal_info,
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _buildMenuItem(
            icon: Icons.notifications_outlined,
            title: l10n.settings_notifications,
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _buildMenuItem(
            icon: Icons.language_outlined,
            title: l10n.settings_language,
            trailing: currentLanguage,
            onTap: () {
              _showLanguageDialog(context, ref, l10n);
            },
          ),
          const SizedBox(height: 12),
          _buildMenuItem(
            icon: Icons.privacy_tip_outlined,
            title: l10n.settings_privacy,
            onTap: () {},
          ),
          const SizedBox(height: 12),
          _buildMenuItem(
            icon: Icons.help_outline,
            title: l10n.settings_support,
            onTap: () {},
          ),
          const SizedBox(height: 24),
          _buildMenuItem(
            icon: Icons.logout,
            title: l10n.settings_logout,
            iconColor: Colors.red,
            textColor: Colors.red,
            onTap: () {
              context.go('/login');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? trailing,
    Color iconColor = kPrimaryColor,
    Color textColor = kDarkText,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              blurRadius: 6,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                ),
              ),
            ),
            if (trailing != null) ...[
              Text(
                trailing,
                style: const TextStyle(fontSize: 14, color: kGreyText),
              ),
              const SizedBox(width: 8),
            ],
            const Icon(Icons.arrow_forward_ios, size: 14, color: kGreyText),
          ],
        ),
      ),
    );
  }
}

void _showLanguageDialog(
  BuildContext context,
  WidgetRef ref,
  AppLocalizations l10n,
) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(l10n.dialog_choose_language),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(l10n.dialog_arabic),
              leading: const Icon(Icons.language),
              onTap: () {
                ref.read(localeProvider.notifier).setLocale(const Locale('ar'));
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text(l10n.dialog_english),
              leading: const Icon(Icons.language),
              onTap: () {
                ref.read(localeProvider.notifier).setLocale(const Locale('en'));
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    },
  );
}
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// //constant colors
// const Color kPrimaryColor = Color(0xFF27A4A7);
// const Color kDarkText = Color(0xFF1B1B1B);
// const Color kGreyText = Color(0xFF757575);

// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         body: Container(
//           width: double.infinity,
//           height: double.infinity,
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.topRight,
//               colors: [
//                 Color.from(alpha: 1, red: 0.89, green: 0.957, blue: 0.965),
//                 Color.fromARGB(255, 162, 234, 236),
//               ],
//             ),
//           ),
//           child: SafeArea(
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   _buildProfileHeader(),
//                   const SizedBox(height: 24),
//                   _buildStatsRow(),
//                   const SizedBox(height: 30),
//                   _buildSettingsList(context),
//                   const SizedBox(height: 30),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildProfileHeader() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: 80,
//             height: 80,
//             decoration: const BoxDecoration(
//               color: Colors.orangeAccent,
//               shape: BoxShape.circle,
//             ),
//             child: const Icon(Icons.person, size: 50, color: Colors.white),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   'أحمد محمد',
//                   style: TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: kDarkText,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 const Text(
//                   'ahmed@example.com',
//                   style: TextStyle(fontSize: 14, color: kGreyText),
//                 ),
//                 const SizedBox(height: 12),
//                 Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 14,
//                     vertical: 6,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(20),
//                     border: Border.all(color: kPrimaryColor, width: 1),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: const [
//                       Icon(Icons.edit_outlined, size: 14, color: kPrimaryColor),
//                       SizedBox(width: 4),
//                       Text(
//                         'تعديل الملف',
//                         style: TextStyle(
//                           fontSize: 12,
//                           fontWeight: FontWeight.bold,
//                           color: kPrimaryColor,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatsRow() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20.0),
//       child: Row(
//         children: [
//           _buildStatItem('45', 'المهام المنجزة'),
//           const SizedBox(width: 12),
//           _buildStatItem('12', 'الأهداف النشطة'),
//           const SizedBox(width: 12),
//           _buildStatItem('4', 'أهداف مكتملة'),
//         ],
//       ),
//     );
//   }

//   Widget _buildStatItem(String number, String label) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(14),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.08),
//               blurRadius: 8,
//               spreadRadius: 1,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           children: [
//             Text(
//               number,
//               style: const TextStyle(
//                 fontSize: 20,
//                 fontWeight: FontWeight.bold,
//                 color: kPrimaryColor,
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               label,
//               style: const TextStyle(fontSize: 12, color: kGreyText),
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   //    BuildContext
//   Widget _buildSettingsList(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 20.0),
//       child: Column(
//         children: [
//           _buildMenuItem(
//             icon: Icons.person_outline,
//             title: 'البيانات الشخصية',
//             onTap: () {},
//           ),
//           const SizedBox(height: 12),
//           _buildMenuItem(
//             icon: Icons.notifications_outlined,
//             title: 'الإشعارات',
//             onTap: () {},
//           ),
//           const SizedBox(height: 12),
//           _buildMenuItem(
//             icon: Icons.language_outlined,
//             title: 'اللغة',
//             trailing: 'العربية',
//             onTap: () {},
//           ),
//           const SizedBox(height: 12),
//           _buildMenuItem(
//             icon: Icons.privacy_tip_outlined,
//             title: 'الخصوصية والأمان',
//             onTap: () {},
//           ),
//           const SizedBox(height: 12),
//           _buildMenuItem(
//             icon: Icons.help_outline,
//             title: 'المساعدة والدعم',
//             onTap: () {},
//           ),
//           const SizedBox(height: 24),

//           //logout
//           _buildMenuItem(
//             icon: Icons.logout,
//             title: 'تسجيل الخروج',
//             iconColor: Colors.red,
//             textColor: Colors.red,
//             onTap: () {
//               context.go('/login');
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildMenuItem({
//     required IconData icon,
//     required String title,
//     String? trailing,
//     Color iconColor = kPrimaryColor,
//     Color textColor = kDarkText,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(14),
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(14),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.05),
//               blurRadius: 6,
//               spreadRadius: 1,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             Icon(icon, color: iconColor, size: 24),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Text(
//                 title,
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w500,
//                   color: textColor,
//                 ),
//               ),
//             ),
//             if (trailing != null) ...[
//               Text(
//                 trailing,
//                 style: const TextStyle(fontSize: 14, color: kGreyText),
//               ),
//               const SizedBox(width: 8),
//             ],
//             const Icon(Icons.arrow_forward_ios, size: 14, color: kGreyText),
//           ],
//         ),
//       ),
//     );
//   }
// }
