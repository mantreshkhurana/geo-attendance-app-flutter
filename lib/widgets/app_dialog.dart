import 'package:flutter/material.dart';

/// Themed Material dialogs replacing the old `CupertinoAlertDialog`s.
class AppDialog {
  AppDialog._();

  /// A simple info/error dialog with a single dismiss action.
  static Future<void> info(
    BuildContext context, {
    required String title,
    required String message,
    String actionLabel = 'OK',
    bool isError = false,
  }) {
    final scheme = Theme.of(context).colorScheme;
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: TextStyle(color: isError ? scheme.error : null),
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(actionLabel),
          ),
        ],
      ),
    );
  }

  /// A confirm/cancel dialog. Resolves to `true` when confirmed.
  static Future<bool> confirm(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    bool destructive = false,
  }) async {
    final scheme = Theme.of(context).colorScheme;
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelLabel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              confirmLabel,
              style: TextStyle(color: destructive ? scheme.error : null),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }
}
