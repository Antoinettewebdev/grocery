import 'package:flutter/material.dart';

import '../models/grocery_models.dart';
import '../services/grocery_storage.dart';
import '../theme/grocery_typography.dart';
import '../widgets/grocery_backdrop.dart';
import '../widgets/grocery_glass_panel.dart';
import 'list_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.storage});

  final GroceryStorage storage;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<GroceryList> _lists = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadLists();
  }

  Future<void> _loadLists() async {
    final lists = await widget.storage.loadLists();
    if (!mounted) return;
    setState(() {
      _lists
        ..clear()
        ..addAll(lists);
      _loading = false;
    });
  }

  Future<void> _saveLists() async {
    await widget.storage.saveLists(_lists);
  }

  void _onListChanged() {
    setState(() {});
    _saveLists();
  }

  String _newListId() =>
      '${DateTime.now().microsecondsSinceEpoch}-${_lists.length}';

  void _openList(GroceryList list) {
    Navigator.of(context).push<void>(
      MaterialPageRoute(
        builder: (context) => ListDetailScreen(
          list: list,
          onListChanged: _onListChanged,
        ),
      ),
    );
  }

  Future<void> _createList() async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New grocery list'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(
            hintText: 'List name',
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) => Navigator.pop(context, value.trim()),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Create'),
          ),
        ],
      ),
    );
    if (name == null || name.isEmpty) return;
    setState(() {
      _lists.add(GroceryList(id: _newListId(), name: name));
    });
    await _saveLists();
  }

  Future<void> _deleteList(GroceryList list) async {
    setState(() => _lists.remove(list));
    await _saveLists();
  }

  Future<void> _confirmDeleteList(GroceryList list) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete list?'),
        content: Text('“${list.name}” will be removed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok == true) await _deleteList(list);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 64,
        title: Text(
          'Grocery lists',
          style: GroceryTypography.appBarTitle(theme.textTheme),
        ),
        centerTitle: false,
        titleSpacing: 20,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        foregroundColor: GroceryTypography.primaryText,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _loading ? null : _createList,
        elevation: 6,
        highlightElevation: 8,
        icon: const Icon(Icons.add_rounded, size: 22),
        label: Text(
          'New list',
          style: GroceryTypography.fabLabel(scheme.onPrimary),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          const GroceryBackdrop(),
          if (_loading)
            const Center(child: CircularProgressIndicator())
          else if (_lists.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'Create a list to start shopping.\nTap “New list” below.',
                  textAlign: TextAlign.center,
                  style: GroceryTypography.emptyState(theme.textTheme),
                ),
              ),
            )
          else
            ListView.builder(
              padding: EdgeInsets.fromLTRB(
                20,
                MediaQuery.paddingOf(context).top + 64 + 12,
                20,
                96,
              ),
              itemCount: _lists.length,
              itemBuilder: (context, index) {
                final list = _lists[index];
                final bought = list.boughtCount;
                final total = list.itemCount;
                final subtitle = total == 0
                    ? 'No items yet'
                    : '$bought of $total bought';

                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: GroceryGlassPanel(
                    onTap: () => _openList(list),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 18, 8, 18),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 26,
                            backgroundColor: scheme.primaryContainer,
                            foregroundColor: scheme.onPrimaryContainer,
                            child: const Icon(
                              Icons.shopping_bag_outlined,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 18),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  list.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GroceryTypography.listCardTitle(
                                    theme.textTheme,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  subtitle,
                                  style: GroceryTypography.listCardSubtitle(
                                    theme.textTheme,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded),
                            iconSize: 22,
                            color: GroceryTypography.iconColor,
                            visualDensity: VisualDensity.compact,
                            padding: const EdgeInsets.all(8),
                            constraints: const BoxConstraints(
                              minWidth: 40,
                              minHeight: 40,
                            ),
                            tooltip: 'Delete list',
                            onPressed: () => _confirmDeleteList(list),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 6),
                            child: Icon(
                              Icons.chevron_right_rounded,
                              size: 28,
                              color: GroceryTypography.iconColor
                                  .withValues(alpha: 0.85),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
