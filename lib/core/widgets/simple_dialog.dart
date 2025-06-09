import 'package:flutter/material.dart';

class SimpleDialogs {
  static Future<void> showAlertDialog(
    BuildContext context, {
    required String title,
    required String content,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    bool isDismissible = true,
  }) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: isDismissible,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            if (cancelText != null)
              TextButton(
                child: Text(cancelText),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              ),
            if (confirmText != null)
              TextButton(
                child: Text(confirmText),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  onConfirm?.call();
                },
              ),
          ],
        );
      },
    );
  }

  static Future<T?> showCustomDialog<T>(
    BuildContext context, {
    required Widget content,
    bool isDismissible = true,
    EdgeInsetsGeometry? contentPadding,
  }) async {
    return showDialog<T>(
      context: context,
      barrierDismissible: isDismissible,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: contentPadding ?? const EdgeInsets.all(20.0),
            child: content,
          ),
        );
      },
    );
  }
}