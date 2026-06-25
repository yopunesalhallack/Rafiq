import 'package:flutter/material.dart';

//should move to constant file
const Color kPrimaryColor = Color(0xFF27A4A7);
const Color kDarkText = Color(0xFF1B1B1B);
const Color kGreyText = Color(0xFF757575);
const Color kLightCream = Color(0xFFFEF3E2);

class AddTaskBottomSheet extends StatefulWidget {
  final VoidCallback? onTaskAdded;

  const AddTaskBottomSheet({super.key, this.onTaskAdded});

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  bool _isAIAssigned = true;

  @override
  void dispose() {
    _titleController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  void _saveTask(BuildContext context) {
    //save task/goal logic
    print('Task Title: ${_titleController.text}');
    print('AI Assigned: $_isAIAssigned');

    // إغلاق النافذة
    Navigator.pop(context);

    if (widget.onTaskAdded != null) {
      widget.onTaskAdded!();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close, color: kDarkText),
                  onPressed: () => Navigator.pop(context),
                ),
                const Text(
                  'إضافة هدف',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: kDarkText,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            const Text(
              'اسم الهدف',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: kDarkText,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: 'مكالمة العميل',
                hintStyle: TextStyle(color: kGreyText.withOpacity(0.5)),
                filled: true,
                fillColor: const Color(0xFFF5F6F7),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // date
            const Text(
              'التاريخ',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: kDarkText,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6F7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 18,
                        color: kGreyText,
                      ),
                      SizedBox(width: 8),
                      Text(
                        '2026 التاريخ',
                        style: TextStyle(color: kGreyText, fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // time
            const Text(
              'الوقت',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: kDarkText,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6F7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'الآن',
                    style: TextStyle(color: kGreyText, fontSize: 14),
                  ),
                  Text(
                    'الوقت',
                    style: TextStyle(color: kGreyText, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // pariority
            const Text(
              'الأولوية',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: kDarkText,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: kLightCream,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.keyboard_arrow_down, color: kDarkText),
                  Text(
                    'High',
                    style: TextStyle(
                      color: kDarkText,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 6. تخصيص AI
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'تخصيص AI',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: kDarkText,
                  ),
                ),
                Switch(
                  value: _isAIAssigned,
                  activeColor: Colors.white,
                  activeTrackColor: kPrimaryColor,
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Colors.grey[300],
                  onChanged: (bool value) {
                    setState(() {
                      _isAIAssigned = value;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // 7. زر الإضافة
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () => _saveTask(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'إضافة مهمة',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
