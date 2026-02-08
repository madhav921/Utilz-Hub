import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/models/tool_category.dart';
import '../../core/services/saved_results_service.dart';
import '../../core/services/export_service.dart';
import '../home/tool_router.dart';

/// Screen showing all saved calculation/conversion results.
///
/// Results are grouped by category, sorted newest-first.
/// Each card can be expanded to see full data, exported, or deleted.
class SavedResultsScreen extends StatefulWidget {
  const SavedResultsScreen({super.key});

  @override
  State<SavedResultsScreen> createState() => _SavedResultsScreenState();
}

class _SavedResultsScreenState extends State<SavedResultsScreen> {
  List<SavedResult> _results = [];
  bool _loading = true;
  String _filterCategory = 'All';

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final results = await SavedResultsService.loadAll();
    if (!mounted) return;
    setState(() {
      _results = results;
      _loading = false;
    });
  }

  List<String> get _categories {
    final cats = _results.map((r) => r.categoryName).toSet().toList()..sort();
    return ['All', ...cats];
  }

  List<SavedResult> get _filtered {
    if (_filterCategory == 'All') return _results;
    return _results.where((r) => r.categoryName == _filterCategory).toList();
  }

  Future<void> _delete(SavedResult result) async {
    await SavedResultsService.delete(result.id);
    _load();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Result deleted')),
    );
  }

  void _editResult(SavedResult result) {
    // Look up the tool and navigate to its screen
    final tool = allToolsById[result.toolId];
    if (tool == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tool not found')),
      );
      return;
    }
    final cat = categoryForTool(result.toolId);
    final color = cat?.color ?? Colors.blueGrey;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ToolRouter.getScreen(tool, color),
      ),
    );
  }

  Future<void> _clearAll() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear All Saved?'),
        content: const Text(
            'This will permanently delete all saved results. This cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Clear All')),
        ],
      ),
    );
    if (confirm == true) {
      await SavedResultsService.clearAll();
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Results'),
        actions: [
          if (_results.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              tooltip: 'Clear all',
              onPressed: _clearAll,
            ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _results.isEmpty
              ? _buildEmptyState()
              : _buildContent(theme),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bookmark_border, size: 80, color: Colors.grey.shade600),
          const SizedBox(height: 16),
          const Text('No saved results yet',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Text(
            'Tap the bookmark icon on any tool\nto save a result here.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ThemeData theme) {
    return Column(
      children: [
        // Category filter chips
        if (_categories.length > 2)
          SizedBox(
            height: 50,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final cat = _categories[i];
                final selected = _filterCategory == cat;
                return FilterChip(
                  label: Text(cat),
                  selected: selected,
                  onSelected: (_) =>
                      setState(() => _filterCategory = cat),
                );
              },
            ),
          ),

        // Results list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: _filtered.length,
            itemBuilder: (_, i) => _ResultCard(
              result: _filtered[i],
              onDelete: () => _delete(_filtered[i]),
              onEdit: () => _editResult(_filtered[i]),
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════
// Individual saved result card
// ═══════════════════════════════════════════════════════════

class _ResultCard extends StatelessWidget {
  final SavedResult result;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const _ResultCard({
    required this.result,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final ts = DateFormat('dd MMM yyyy, hh:mm a').format(result.savedAt);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ExpansionTile(
        leading: const Icon(Icons.bookmark, size: 28),
        title: Text(result.toolName,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text('$ts  •  ${result.categoryName}',
            style: const TextStyle(fontSize: 12)),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                // Data rows
                ...result.data.entries.map(
                  (e) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(e.key,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500)),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Text(e.value,
                              textAlign: TextAlign.end,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ),
                ),
                if (result.note != null && result.note!.isNotEmpty) ...[
                  const Divider(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Note: ${result.note}',
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey.shade500)),
                  ),
                ],
                const Divider(),
                // Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      label: const Text('Edit'),
                      onPressed: onEdit,
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      icon: const Icon(Icons.share_outlined, size: 18),
                      label: const Text('Share'),
                      onPressed: () => ExportService.export(
                        title: result.toolName,
                        data: result.data,
                        format: ExportFormat.share,
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      icon:
                          Icon(Icons.delete_outline, size: 18, color: Colors.red.shade300),
                      label: Text('Delete',
                          style: TextStyle(color: Colors.red.shade300)),
                      onPressed: onDelete,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
