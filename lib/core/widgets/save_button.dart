import 'package:flutter/material.dart';
import '../services/saved_results_service.dart';

/// AppBar action button to save a result to the local saved folder.
///
/// Shows a confirmation snackbar with optional note input.
class SaveButton extends StatelessWidget {
  final String toolId;
  final String toolName;
  final String categoryName;
  final Map<String, String> data;
  final Color accentColor;

  const SaveButton({
    super.key,
    required this.toolId,
    required this.toolName,
    required this.categoryName,
    required this.data,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.bookmark_add_outlined, color: accentColor),
      tooltip: 'Save result',
      onPressed: () => _save(context),
    );
  }

  Future<void> _save(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);

    // Optional note via bottom sheet
    final note = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => _NoteSheet(accentColor: accentColor),
    );

    // null means cancelled — but empty string means no note (save anyway)
    if (note == null) return;

    await SavedResultsService.save(
      toolId: toolId,
      toolName: toolName,
      categoryName: categoryName,
      data: data,
      note: note.isEmpty ? null : note,
    );

    messenger.showSnackBar(
      SnackBar(
        content: const Text('Result saved ✓'),
        backgroundColor: accentColor.withValues(alpha: 0.9),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

/// Bottom sheet for adding an optional note when saving.
class _NoteSheet extends StatefulWidget {
  final Color accentColor;
  const _NoteSheet({required this.accentColor});

  @override
  State<_NoteSheet> createState() => _NoteSheetState();
}

class _NoteSheetState extends State<_NoteSheet> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Save Result',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: widget.accentColor)),
          const SizedBox(height: 12),
          TextField(
            controller: _ctrl,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Add a note (optional)',
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                icon: const Icon(Icons.bookmark_add),
                label: const Text('Save'),
                style: FilledButton.styleFrom(
                    backgroundColor: widget.accentColor),
                onPressed: () => Navigator.pop(context, _ctrl.text),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
