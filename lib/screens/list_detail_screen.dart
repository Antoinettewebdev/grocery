import 'package:flutter/material.dart';

import '../models/grocery_models.dart';
import '../theme/grocery_typography.dart';
import '../widgets/grocery_backdrop.dart';
import '../widgets/grocery_glass_panel.dart';

class ListDetailScreen extends StatefulWidget {
  const ListDetailScreen({
    super.key,
    required this.list,
    required this.onListChanged,
  });

  final GroceryList list;
  final VoidCallback onListChanged;

  @override
  State<ListDetailScreen> createState() => _ListDetailScreenState();
}

class _ListDetailScreenState extends State<ListDetailScreen> {
  void _notify() {
    widget.onListChanged();
    setState(() {});
  }

  String _newId() =>
      '${DateTime.now().microsecondsSinceEpoch}-${widget.list.items.length}';

  Future<void> _addItem() async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add item'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          decoration: const InputDecoration(
            hintText: 'Item name',
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
            child: const Text('Add'),
          ),
        ],
      ),
    );
    if (name == null || name.isEmpty) return;
    widget.list.items.add(
      GroceryItem(id: _newId(), name: name),
    );
    _notify();
  }

  void _toggleBought(GroceryItem item) {
    item.bought = !item.bought;
    _notify();
  }

  void _deleteItem(GroceryItem item) {
    widget.list.items.remove(item);
    _notify();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = widget.list.items;
    final scheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 64,
        title: Text(
          widget.list.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
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
        onPressed: _addItem,
        elevation: 6,
        highlightElevation: 8,
        icon: const Icon(Icons.add_rounded, size: 22),
        label: Text(
          'Add item',
          style: GroceryTypography.fabLabel(scheme.onPrimary),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          const GroceryBackdrop(),
          if (items.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'No items yet.\nTap “Add item” to get started.',
                  textAlign: TextAlign.center,
                  style: GroceryTypography.emptyState(theme.textTheme),
                ),
              ),
            )
          else
            ListView.separated(
              padding: EdgeInsets.fromLTRB(
                20,
                MediaQuery.paddingOf(context).top + 64 + 12,
                20,
                96,
              ),
              itemCount: items.length,
              separatorBuilder: (context, _) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final item = items[index];
                return GroceryGlassPanel(
                  borderRadius: BorderRadius.circular(16),
                  child: CheckboxListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    tileColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    value: item.bought,
                    onChanged: (_) => _toggleBought(item),
                    activeColor: scheme.primary,
                    checkColor: scheme.onPrimary,
                    title: Text(
                      item.name,
                      style: GroceryTypography.itemTitle(
                        bought: item.bought,
                      ),
                    ),
                    secondary: IconButton(
                      icon: const Icon(Icons.delete_outline_rounded),
                      iconSize: 22,
                      color: GroceryTypography.iconColor,
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                      ),
                      tooltip: 'Remove item',
                      onPressed: () => _deleteItem(item),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
