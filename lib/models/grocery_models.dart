class GroceryItem {
  GroceryItem({
    required this.id,
    required this.name,
    this.bought = false,
  });

  final String id;
  String name;
  bool bought;

  int get boughtFlag => bought ? 1 : 0;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'bought': bought,
      };

  factory GroceryItem.fromJson(Map<String, dynamic> json) {
    return GroceryItem(
      id: json['id'] as String,
      name: json['name'] as String,
      bought: json['bought'] as bool? ?? false,
    );
  }
}

class GroceryList {
  GroceryList({
    required this.id,
    required this.name,
    List<GroceryItem>? items,
  }) : items = items ?? [];

  final String id;
  String name;
  final List<GroceryItem> items;

  int get itemCount => items.length;

  int get boughtCount => items.fold(0, (sum, i) => sum + i.boughtFlag);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'items': items.map((i) => i.toJson()).toList(),
      };

  factory GroceryList.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'];
    final items = itemsJson is List
        ? itemsJson
            .whereType<Map>()
            .map((e) => GroceryItem.fromJson(Map<String, dynamic>.from(e)))
            .toList()
        : <GroceryItem>[];

    return GroceryList(
      id: json['id'] as String,
      name: json['name'] as String,
      items: items,
    );
  }
}
