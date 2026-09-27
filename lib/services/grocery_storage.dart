import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/grocery_models.dart';

class GroceryStorage {
  GroceryStorage(this._prefs);

  static const _listsKey = 'grocery_lists';

  final SharedPreferences _prefs;

  /// Reloads from disk first so a new process (app restart) never reads a stale cache.
  Future<List<GroceryList>> loadLists() async {
    await _prefs.reload();
    final raw = _prefs.getString(_listsKey);
    if (raw == null || raw.isEmpty) return [];

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return [];
      return decoded
          .whereType<Map>()
          .map((e) => GroceryList.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveLists(List<GroceryList> lists) async {
    final encoded = jsonEncode(lists.map((l) => l.toJson()).toList());
    final ok = await _prefs.setString(_listsKey, encoded);
    if (!ok) {
      throw StateError('Could not write grocery lists to SharedPreferences.');
    }
  }
}
