import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Animated present/absent checkbox replacing the old `CupertinoSwitch`.
///
/// Tapping flips [value] and fires [onChanged] (used by teachers to move a
/// student between presentStudents / absentStudents in Firestore).
class AttendanceCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const AttendanceCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final color = value ? AppColors.present : AppColors.absent;
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          color: value ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(9),
          border: Border.all(color: color, width: 2),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 220),
          transitionBuilder: (child, animation) =>
              ScaleTransition(scale: animation, child: child),
          child: value
              ? const Icon(
                  Icons.check_rounded,
                  key: ValueKey('checked'),
                  color: Colors.white,
                  size: 20,
                )
              : const SizedBox(key: ValueKey('unchecked')),
        ),
      ),
    );
  }
}
