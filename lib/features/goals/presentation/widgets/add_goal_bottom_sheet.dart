import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rafiq_app/core/utils/providers.dart';
import 'package:rafiq_app/features/goals/data/models/goal.dart';
import 'package:rafiq_app/features/goals/domain/repositories/goal_repository.dart';

const Color kPrimaryColor = Color(0xFF27A4A7);

class AddGoalBottomSheet extends ConsumerStatefulWidget {
  const AddGoalBottomSheet({super.key});

  @override
  ConsumerState<AddGoalBottomSheet> createState() => _AddGoalBottomSheetState();
}

class _AddGoalBottomSheetState extends ConsumerState<AddGoalBottomSheet> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _targetDate;
  bool _isAiEnabled = false;

  late final GoalRepository _goalRepository;

  @override
  void initState() {
    super.initState();
    _goalRepository = ref.read(goalRepositoryProvider);
  }

  Future<void> _saveGoal() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('يرجى إدخال عنوان الهدف')));
      return;
    }

    final newGoal = Goal()
      ..title = _titleController.text.trim()
      ..description = _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim()
      ..targetDate = _targetDate
      ..isAiEnabled = _isAiEnabled
      ..status = GoalStatus.active
      ..isSynced = false
      ..createdAt = DateTime.now();

    await _goalRepository.addGoal(newGoal);
    if (context.mounted) Navigator.pop(context);
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
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
                const Text(
                  'إضافة هدف',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'عنوان الهدف',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'وصف الهدف (اختياري)',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2030),
                );
                if (picked != null) setState(() => _targetDate = picked);
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 18),
                    Text(
                      _targetDate != null
                          ? '${_targetDate!.year}-${_targetDate!.month}-${_targetDate!.day}'
                          : 'تاريخ الانتهاء (اختياري)',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'تخصيص AI',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
                Switch(
                  value: _isAiEnabled,
                  onChanged: (v) => setState(() => _isAiEnabled = v),
                  activeThumbColor: const Color(0xFF27A4A7),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _saveGoal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF27A4A7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'إضافة هدف',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
