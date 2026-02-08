import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Service to create pinned shortcuts on Android home screens.
///
/// Uses a MethodChannel to call native Android
/// [ShortcutManagerCompat.requestPinShortcut].
class HomeShortcutService {
  static const _channel = MethodChannel('com.utilzhub/shortcuts');

  /// Returns the tool-id from the launching intent, if any.
  static Future<String?> getInitialToolId() async {
    try {
      final result =
          await _channel.invokeMethod<String>('getInitialToolId');
      return (result != null && result.isNotEmpty) ? result : null;
    } catch (_) {
      return null;
    }
  }

  /// Returns `true` if the platform supports pinned shortcuts.
  static Future<bool> get isSupported async {
    try {
      final result = await _channel.invokeMethod<bool>('isSupported');
      return result ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Request the OS to pin a shortcut for [toolId] on the home screen.
  static Future<bool> pinTool({
    required String toolId,
    required String toolName,
    required IconData icon,
  }) async {
    try {
      final result = await _channel.invokeMethod<bool>('pinShortcut', {
        'id': toolId,
        'label': toolName,
        'iconCodePoint': icon.codePoint,
      });
      return result ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Shows a confirmation dialog and, if accepted, pins the tool shortcut.
  ///
  /// Returns `true` if the shortcut was successfully requested.
  static Future<bool> confirmAndPin(
    BuildContext context, {
    required String toolId,
    required String toolName,
    required IconData icon,
    required Color accentColor,
  }) async {
    final supported = await isSupported;
    if (!supported) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Home screen shortcuts are not supported on this device'),
          ),
        );
      }
      return false;
    }

    if (!context.mounted) return false;

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        icon: Icon(Icons.add_to_home_screen, color: accentColor, size: 36),
        title: const Text('Add to Home Screen'),
        content: Text(
          'Add "$toolName" as a shortcut on your home screen for quick access?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton.icon(
            icon: const Icon(Icons.add_to_home_screen, size: 18),
            label: const Text('Add'),
            onPressed: () => Navigator.pop(ctx, true),
            style: FilledButton.styleFrom(backgroundColor: accentColor),
          ),
        ],
      ),
    );

    if (ok != true) return false;

    final pinned = await pinTool(
      toolId: toolId,
      toolName: toolName,
      icon: icon,
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            pinned
                ? '"$toolName" shortcut added!'
                : 'Could not add shortcut. Please try again.',
          ),
        ),
      );
    }
    return pinned;
  }
}
