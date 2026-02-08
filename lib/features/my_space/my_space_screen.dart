import 'package:flutter/material.dart';
import '../../core/models/tool_category.dart';
import '../../core/services/cache_service.dart';
import '../home/tool_router.dart';
import 'custom_tool_builder_screen.dart';

/// "My Space" tab — user-managed folders with favourites at the top.
///
/// • **Everyday Essentials** is a built-in favourites folder (max 10 tools).
/// • Users can create unlimited custom folders and add any tools to them.
/// • All data persists via [CacheService].
class MySpaceScreen extends StatefulWidget {
  const MySpaceScreen({super.key});

  @override
  State<MySpaceScreen> createState() => _MySpaceScreenState();
}

class _MySpaceScreenState extends State<MySpaceScreen> {
  /// Built-in favourite IDs.
  List<String> _favouriteIds = [];
  bool _favouritesLoaded = false;

  /// Custom folders: [{name, icon (codePoint), color (value), toolIds: []}]
  List<_Folder> _folders = [];

  @override
  void initState() {
    super.initState();
    _loadFavourites();
    _loadFolders();
  }

  // ── Favourites ──────────────────────────────────────────

  Future<void> _loadFavourites() async {
    final favs = await CacheService.loadFavourites();
    if (mounted) {
      setState(() {
        _favouriteIds = favs ?? [];
        _favouritesLoaded = true;
      });
    }
  }

  List<Tool> get _favouriteTools => _favouriteIds
      .where((id) => allToolsById.containsKey(id))
      .map((id) => allToolsById[id]!)
      .toList();

  Future<void> _removeFavourite(Tool tool) async {
    await CacheService.toggleFavourite(tool.id);
    setState(() => _favouriteIds.remove(tool.id));
  }

  Future<void> _addFavourite() async {
    if (_favouriteIds.length >= CacheService.maxFavourites) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum 10 favourites reached')),
      );
      return;
    }
    final tool = await showSearch<Tool?>(
      context: context,
      delegate: _ToolPickerDelegate(
          excludeIds: _favouriteIds.toSet()),
    );
    if (tool != null && mounted) {
      await CacheService.toggleFavourite(tool.id);
      await _loadFavourites();
    }
  }

  // ── Custom Folders ──────────────────────────────────────

  Future<void> _loadFolders() async {
    final raw = await CacheService.loadCustomFolders();
    if (mounted) {
      setState(() {
        _folders = raw.map((m) => _Folder.fromMap(m)).toList();
      });
    }
  }

  Future<void> _saveFolders() async {
    await CacheService.saveCustomFolders(
        _folders.map((f) => f.toMap()).toList());
  }

  void _createFolder() async {
    final result = await _showFolderDialog();
    if (result == null) return;
    setState(() => _folders.add(result));
    await _saveFolders();
  }

  void _editFolder(int index) async {
    final result =
        await _showFolderDialog(existing: _folders[index]);
    if (result == null) return;
    setState(() => _folders[index] = result);
    await _saveFolders();
  }

  void _deleteFolder(int index) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Folder?'),
        content: Text(
            'Delete "${_folders[index].name}" and all its tool shortcuts?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Delete')),
        ],
      ),
    );
    if (ok != true) return;
    setState(() => _folders.removeAt(index));
    await _saveFolders();
  }

  void _addToolToFolder(int index) async {
    final existing = _folders[index].toolIds.toSet();
    final tool = await showSearch<Tool?>(
      context: context,
      delegate: _ToolPickerDelegate(excludeIds: existing),
    );
    if (tool != null && mounted) {
      setState(() => _folders[index].toolIds.add(tool.id));
      await _saveFolders();
    }
  }

  void _removeToolFromFolder(int folderIdx, String toolId) async {
    final toolName = allToolsById[toolId]?.name ?? toolId;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove Tool?'),
        content: Text(
            'Remove "$toolName" from "${_folders[folderIdx].name}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Remove')),
        ],
      ),
    );
    if (ok != true) return;
    setState(() => _folders[folderIdx].toolIds.remove(toolId));
    await _saveFolders();
  }

  // ── Folder dialog ───────────────────────────────────────

  static const _folderIcons = <IconData>[
    Icons.folder,
    Icons.work,
    Icons.star,
    Icons.bookmark,
    Icons.category,
    Icons.build,
    Icons.school,
    Icons.science,
    Icons.home_work,
    Icons.laptop,
    Icons.attach_money,
    Icons.medical_services,
    Icons.construction,
    Icons.calculate,
    Icons.palette,
    Icons.music_note,
  ];

  static const _folderColors = <Color>[
    Color(0xFF3B82F6),
    Color(0xFF10B981),
    Color(0xFFF59E0B),
    Color(0xFFEF4444),
    Color(0xFF8B5CF6),
    Color(0xFFEC4899),
    Color(0xFF14B8A6),
    Color(0xFFF97316),
    Color(0xFF6366F1),
    Color(0xFF0EA5E9),
  ];

  Future<_Folder?> _showFolderDialog({_Folder? existing}) async {
    final nameCtrl =
        TextEditingController(text: existing?.name ?? '');
    int iconIdx = existing != null
        ? _folderIcons.indexWhere(
            (ic) => ic.codePoint == existing.icon.codePoint)
        : 0;
    if (iconIdx < 0) iconIdx = 0;
    int colorIdx = existing != null
        ? _folderColors.indexWhere(
            (c) => c.toARGB32() == existing.color.toARGB32())
        : 0;
    if (colorIdx < 0) colorIdx = 0;

    return showDialog<_Folder>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setInner) {
            return AlertDialog(
              title: Text(
                  existing == null ? 'New Folder' : 'Edit Folder'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Folder name',
                        border: OutlineInputBorder(),
                      ),
                      autofocus: true,
                    ),
                    const SizedBox(height: 16),
                    const Text('Icon',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(_folderIcons.length, (i) {
                        final selected = i == iconIdx;
                        return GestureDetector(
                          onTap: () => setInner(() => iconIdx = i),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: selected
                                  ? _folderColors[colorIdx]
                                      .withValues(alpha: 0.2)
                                  : Colors.transparent,
                              border: selected
                                  ? Border.all(
                                      color: _folderColors[colorIdx],
                                      width: 2)
                                  : null,
                            ),
                            child: Icon(_folderIcons[i],
                                size: 24,
                                color: selected
                                    ? _folderColors[colorIdx]
                                    : Colors.grey),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                    const Text('Color',
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children:
                          List.generate(_folderColors.length, (i) {
                        final selected = i == colorIdx;
                        return GestureDetector(
                          onTap: () => setInner(() => colorIdx = i),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _folderColors[i],
                              border: selected
                                  ? Border.all(
                                      color: Colors.white, width: 3)
                                  : null,
                              boxShadow: selected
                                  ? [
                                      BoxShadow(
                                        color: _folderColors[i]
                                            .withValues(alpha: 0.5),
                                        blurRadius: 8,
                                      )
                                    ]
                                  : null,
                            ),
                            child: selected
                                ? const Icon(Icons.check,
                                    size: 18, color: Colors.white)
                                : null,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Cancel')),
                FilledButton(
                  onPressed: () {
                    final name = nameCtrl.text.trim();
                    if (name.isEmpty) return;
                    Navigator.pop(
                      ctx,
                      _Folder(
                        name: name,
                        icon: _folderIcons[iconIdx],
                        color: _folderColors[colorIdx],
                        toolIds: existing?.toolIds ?? [],
                      ),
                    );
                  },
                  child: Text(existing == null ? 'Create' : 'Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ── Build ───────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final favColor = const Color(0xFFEC4899);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Space'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createFolder,
        icon: const Icon(Icons.create_new_folder),
        label: const Text('New Folder'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 80),
        children: [
          // ── Everyday Essentials Section ──
          _SectionHeader(
            icon: Icons.favorite,
            title: 'Everyday Essentials',
            color: favColor,
            trailing: IconButton(
              icon: const Icon(Icons.add_circle_outline),
              tooltip: 'Add favourite',
              color: favColor,
              onPressed: _addFavourite,
            ),
          ),
          if (_favouritesLoaded && _favouriteTools.isEmpty)
            _EmptyState(
              icon: Icons.favorite_border,
              color: favColor,
              title: 'Your Favourites',
              subtitle:
                  'Tap the ♡ icon on any tool to add it here for quick access.',
            ),
          if (_favouritesLoaded && _favouriteTools.isNotEmpty)
            _ToolGrid(
              tools: _favouriteTools,
              color: favColor,
              onTap: (tool) => _openTool(tool, favColor),
              onLongPress: (tool) => _showFavRemoveDialog(tool),
            ),

          const SizedBox(height: 20),

          // ── Custom Tool Builder (Coming Soon) ──
          _CustomToolBuilderBanner(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => const CustomToolBuilderScreen()),
            ),
          ),

          const SizedBox(height: 20),

          // ── Custom Folders ──
          if (_folders.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.only(left: 4, bottom: 8),
              child: Text('My Folders',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
            ),
            ..._folders.asMap().entries.map((entry) {
              final idx = entry.key;
              final folder = entry.value;
              return _FolderCard(
                folder: folder,
                onEdit: () => _editFolder(idx),
                onDelete: () => _deleteFolder(idx),
                onAddTool: () => _addToolToFolder(idx),
                onToolTap: (tool) => _openTool(tool, folder.color),
                onToolRemove: (toolId) =>
                    _removeToolFromFolder(idx, toolId),
              );
            }),
          ],

          if (_folders.isEmpty && _favouritesLoaded && _favouriteTools.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 32),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.create_new_folder_outlined,
                        size: 56, color: Colors.grey.shade400),
                    const SizedBox(height: 12),
                    Text(
                      'Create folders to organise your tools',
                      style: TextStyle(
                          color: Colors.grey.shade600, fontSize: 15),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _openTool(Tool tool, Color color) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => ToolRouter.getScreen(tool, color)),
    );
  }

  void _showFavRemoveDialog(Tool tool) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove Favourite?'),
        content: Text(
            'Remove "${tool.name}" from Everyday Essentials?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () {
                Navigator.pop(ctx);
                _removeFavourite(tool);
              },
              child: const Text('Remove')),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
// Data model for custom folders
// ═══════════════════════════════════════════════════════════

class _Folder {
  String name;
  IconData icon;
  Color color;
  List<String> toolIds;

  _Folder({
    required this.name,
    required this.icon,
    required this.color,
    List<String>? toolIds,
  }) : toolIds = toolIds ?? [];

  Map<String, dynamic> toMap() => {
        'name': name,
        'icon': icon.codePoint,
        'color': color.toARGB32(),
        'toolIds': toolIds,
      };

  /// Reverse-lookup from codePoint to one of the known [_folderIcons].
  /// This avoids `IconData(...)` which blocks icon tree-shaking.
  static IconData _iconFromCodePoint(int codePoint) {
    for (final ic in _MySpaceScreenState._folderIcons) {
      if (ic.codePoint == codePoint) return ic;
    }
    return Icons.folder; // fallback
  }

  factory _Folder.fromMap(Map<String, dynamic> m) => _Folder(
        name: m['name'] as String,
        icon: _iconFromCodePoint(m['icon'] as int),
        color: Color(m['color'] as int),
        toolIds: (m['toolIds'] as List).cast<String>(),
      );

  List<Tool> get tools => toolIds
      .where((id) => allToolsById.containsKey(id))
      .map((id) => allToolsById[id]!)
      .toList();
}

// ═══════════════════════════════════════════════════════════
// Shared widgets
// ═══════════════════════════════════════════════════════════

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final Widget? trailing;

  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.color,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(width: 8),
          Text(title,
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: color)),
          const Spacer(),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;

  const _EmptyState({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: color.withValues(alpha: 0.06),
      ),
      child: Column(
        children: [
          Icon(icon, size: 48, color: color.withValues(alpha: 0.4)),
          const SizedBox(height: 10),
          Text(title,
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(subtitle,
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontSize: 13, color: Colors.grey.shade600)),
        ],
      ),
    );
  }
}

class _ToolGrid extends StatelessWidget {
  final List<Tool> tools;
  final Color color;
  final void Function(Tool) onTap;
  final void Function(Tool) onLongPress;

  const _ToolGrid({
    required this.tools,
    required this.color,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.8,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
      ),
      itemCount: tools.length,
      itemBuilder: (context, i) {
        final tool = tools[i];
        return GestureDetector(
          onTap: () => onTap(tool),
          onLongPress: () => onLongPress(tool),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withValues(alpha: 0.12),
                ),
                child: Icon(tool.icon, size: 26, color: color),
              ),
              const SizedBox(height: 4),
              Text(
                tool.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    fontSize: 10, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FolderCard extends StatelessWidget {
  final _Folder folder;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onAddTool;
  final void Function(Tool) onToolTap;
  final void Function(String toolId) onToolRemove;

  const _FolderCard({
    required this.folder,
    required this.onEdit,
    required this.onDelete,
    required this.onAddTool,
    required this.onToolTap,
    required this.onToolRemove,
  });

  @override
  Widget build(BuildContext context) {
    final tools = folder.tools;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: folder.color.withValues(alpha: 0.15),
                  child:
                      Icon(folder.icon, color: folder.color, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(folder.name,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: folder.color)),
                ),
                PopupMenuButton(
                  icon: const Icon(Icons.more_vert, size: 20),
                  itemBuilder: (_) => [
                    const PopupMenuItem(
                        value: 'edit',
                        child: Row(children: [
                          Icon(Icons.edit, size: 18),
                          SizedBox(width: 8),
                          Text('Edit Folder'),
                        ])),
                    const PopupMenuItem(
                        value: 'add',
                        child: Row(children: [
                          Icon(Icons.add, size: 18),
                          SizedBox(width: 8),
                          Text('Add Tool'),
                        ])),
                    const PopupMenuItem(
                        value: 'delete',
                        child: Row(children: [
                          Icon(Icons.delete, size: 18, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete Folder',
                              style: TextStyle(color: Colors.red)),
                        ])),
                  ],
                  onSelected: (val) {
                    switch (val) {
                      case 'edit':
                        onEdit();
                      case 'add':
                        onAddTool();
                      case 'delete':
                        onDelete();
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Tools grid
            if (tools.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Center(
                  child: Text('No tools yet — tap ⋮ to add',
                      style: TextStyle(
                          color: Colors.grey.shade500, fontSize: 13)),
                ),
              )
            else
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 6,
                  mainAxisSpacing: 6,
                ),
                itemCount: tools.length,
                itemBuilder: (ctx, i) {
                  final tool = tools[i];
                  return GestureDetector(
                    onTap: () => onToolTap(tool),
                    onLongPress: () => onToolRemove(tool.id),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                folder.color.withValues(alpha: 0.12),
                          ),
                          child: Icon(tool.icon,
                              size: 26, color: folder.color),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tool.name,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}

/// Banner card promoting the upcoming Custom Tool Builder feature.
class _CustomToolBuilderBanner extends StatelessWidget {
  final VoidCallback onTap;

  const _CustomToolBuilderBanner({required this.onTap});

  static const _accent = Color(0xFF6366F1);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              _accent.withValues(alpha: isDark ? 0.18 : 0.12),
              _accent.withValues(alpha: isDark ? 0.06 : 0.04),
            ],
          ),
          border: Border.all(
            color: _accent.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _accent.withValues(alpha: 0.15),
              ),
              child: const Icon(Icons.build_circle_outlined,
                  size: 28, color: _accent),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Text('Custom Tool Builder',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: _accent)),
                      SizedBox(width: 8),
                      _ComingSoonChip(),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Build your own calculators and converters',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? Colors.grey.shade400
                          : Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right,
                color: _accent.withValues(alpha: 0.6)),
          ],
        ),
      ),
    );
  }
}

class _ComingSoonChip extends StatelessWidget {
  const _ComingSoonChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFF6366F1).withValues(alpha: 0.15),
      ),
      child: const Text(
        'COMING SOON',
        style: TextStyle(
          fontSize: 9,
          fontWeight: FontWeight.bold,
          color: Color(0xFF6366F1),
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

/// Tool picker search delegate.
class _ToolPickerDelegate extends SearchDelegate<Tool?> {
  final Set<String> excludeIds;

  _ToolPickerDelegate({required this.excludeIds});

  @override
  List<Widget> buildActions(BuildContext context) =>
      [IconButton(icon: const Icon(Icons.clear), onPressed: () => query = '')];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null));

  @override
  Widget buildResults(BuildContext context) => _build(context);

  @override
  Widget buildSuggestions(BuildContext context) => _build(context);

  Widget _build(BuildContext context) {
    final q = query.toLowerCase();
    final all = <Tool>[];
    for (final cat in defaultCategories) {
      for (final tool in cat.tools) {
        if (!excludeIds.contains(tool.id) &&
            (tool.name.toLowerCase().contains(q) ||
                tool.description.toLowerCase().contains(q))) {
          all.add(tool);
        }
      }
    }
    if (all.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 56, color: Colors.grey),
            SizedBox(height: 12),
            Text('No tools found',
                style: TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
      );
    }
    return ListView.builder(
      itemCount: all.length,
      itemBuilder: (_, i) {
        final tool = all[i];
        return ListTile(
          leading: Icon(tool.icon),
          title: Text(tool.name),
          subtitle: Text(tool.description),
          onTap: () => close(context, tool),
        );
      },
    );
  }
}
