class Item {
  final int? id;
  final String code; // matrix code
  final String name;
  final String type;
  final String status;
  final int usageHours;
  final String damageNotes;

  Item({
    this.id,
    required this.code,
    required this.name,
    required this.type,
    required this.status,
    required this.usageHours,
    required this.damageNotes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'type': type,
      'status': status,
      'usageHours': usageHours,
      'damageNotes': damageNotes,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'],
      code: map['code'],
      name: map['name'],
      type: map['type'],
      status: map['status'],
      usageHours: map['usageHours'],
      damageNotes: map['damageNotes'],
    );
  }
}
